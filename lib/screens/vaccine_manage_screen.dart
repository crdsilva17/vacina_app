import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/dto/vaccine_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/repositories/vaccine_repository.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:vacina_app/data/store/vaccine_store.dart';
import 'package:vacina_app/widget/custom_data_column.dart';
import 'package:vacina_app/widget/custom_row_vaccine.dart';

class VaccineManageScreen extends StatefulWidget {
  const VaccineManageScreen({super.key});

  @override
  State<VaccineManageScreen> createState() => _VaccineManageScreenState();
}

class _VaccineManageScreenState extends State<VaccineManageScreen> {
  VaccineStore store = VaccineStore(
    repository: VaccineRepository(client: HttpClient()),
  );

  LocalStore storeLocal = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

  final Map<String, Map<String, TextEditingController>> controllers = {};
  final List<bool> isEditing = [];

  @override
  void initState() {
    super.initState();
    _getVaccines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Vacinas'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),
      body: _body(),
    );
  }

  Widget? _body() {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: CustomDataColumn().columnsVaccine,
              rows: CustomRowVaccine().rowsVaccine(
                context,
                store.stateList.value,
                controllers,
                isEditing,
                _onDelete,
                _onUpdate,
                _setState,
                _setDate,
                _getLocal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getVaccines() async {
    await store.getList();
    if (!mounted) return;
    if (store.error.value.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível carregar as vacinas!')),
      );
    }

    initializerControllers(store.stateList.value);
    for (var i = 0; i < controllers.keys.length; i++) {
      isEditing.add(false);
    }
    setState(() {});
  }

  Future<void> _getLocalId(TextEditingController controller) async {
    await storeLocal.getLocal();
    List<LocalModel> items = storeLocal.state.value;
    if (!mounted) return;
    final option = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index].name),
              onTap: () {
                Navigator.pop(context, items[index].name);
              },
            );
          },
        );
      },
    );
    if (option.toString().isNotEmpty) {
      controller.text = option.toString();
    }
  }

  Future<void> _onUpdateVaccine(String id, VaccineRequest vaccine) async {
    await store.put(id, vaccine);
    setState(() {});
  }

  Future<void> _deleteVaccine(String id) async {
    await store.delete(id);
    await _getVaccines();
  }

  Future<void> _setDate(TextEditingController edit) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        final formatter = DateFormat('dd/MM/yyyy');
        edit.text = formatter.format(picked);
      });
    }
  }

  void _getLocal(TextEditingController controller) {
    _getLocalId(controller);
  }

  void _onUpdate(String id, VaccineRequest vaccine) {
    _onUpdateVaccine(id, vaccine);
  }

  void _onDelete(String id) {
    _deleteVaccine(id);
  }

  void _setState() {
    setState(() {});
  }

  void initializerControllers(List<VaccineModel> vaccines) {
    controllers.clear();

    controllers['add_new'] = {
      'name': TextEditingController(text: 'add_new'),
      'manufacturer': TextEditingController(text: 'add_new'),
      'manufactureDate': TextEditingController(text: 'add_new'),
      'expiryDate': TextEditingController(text: 'add_new'),
      'lot': TextEditingController(text: 'add_new'),
      'minRecommendedAge': TextEditingController(text: 'add_new'),
      'maxRecommendedAge': TextEditingController(text: 'add_new'),
      'posto': TextEditingController(text: 'add_new'),
      'doses': TextEditingController(text: 'add_new'),
      'description': TextEditingController(text: 'add_new'),
      'stockQuantity': TextEditingController(text: 'add_new'),
    };

    for (var vaccine in vaccines) {
      controllers[vaccine.id] = {
        'name': TextEditingController(text: vaccine.name),
        'manufacturer': TextEditingController(text: vaccine.manufacturer),
        'manufactureDate': TextEditingController(text: vaccine.manufactureDate),
        'expiryDate': TextEditingController(text: vaccine.expiryDate),
        'lot': TextEditingController(text: vaccine.lot),
        'minRecommendedAge': TextEditingController(
          text: vaccine.minRecommendedAge.toString(),
        ),
        'maxRecommendedAge': TextEditingController(
          text: vaccine.maxRecommendedAge.toString(),
        ),
        'posto': TextEditingController(text: vaccine.posto),
        'doses': TextEditingController(text: vaccine.doses),
        'description': TextEditingController(text: vaccine.description),
        'stockQuantity': TextEditingController(
          text: vaccine.stockQuantity.toString(),
        ),
      };
    }
  }
}
