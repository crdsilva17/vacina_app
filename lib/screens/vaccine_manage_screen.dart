import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/dto/vaccine_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/data/repositories/vaccine_repository.dart';
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
      body: store.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : _body(),
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
                _onCreate,
                _setState,
                _setDate,
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

  Future<void> _onPost(VaccineRequest vaccine) async {
    await store.post(vaccine);
    await _getVaccines();
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

  void _onCreate(VaccineRequest vaccine) {
    _onPost(vaccine);
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
      'name': TextEditingController(text: ''),
      'manufacturer': TextEditingController(text: ''),
      'manufactureDate': TextEditingController(text: ''),
      'expiryDate': TextEditingController(text: ''),
      'lot': TextEditingController(text: ''),
      'doses': TextEditingController(text: ''),
      'description': TextEditingController(text: ''),
    };

    for (var vaccine in vaccines) {
      controllers[vaccine.id] = {
        'name': TextEditingController(text: vaccine.name),
        'manufacturer': TextEditingController(text: vaccine.manufacturer),
        'manufactureDate': TextEditingController(text: vaccine.manufactureDate),
        'expiryDate': TextEditingController(text: vaccine.expiryDate),
        'lot': TextEditingController(text: vaccine.lot),
        'doses': TextEditingController(text: vaccine.doses),
        'description': TextEditingController(text: vaccine.description),
      };
    }
  }
}
