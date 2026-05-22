import 'package:flutter/material.dart';
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
                store.stateList.value,
                controllers,
                isEditing,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _getVaccines() async {
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

  Future _deleteVaccine(String id) async {
    await store.delete(id);
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
