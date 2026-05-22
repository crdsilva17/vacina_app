import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/http_client.dart';
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

  @override
  void initState() {
    super.initState();
    _getVaccines();
    for (var vaccine in store.stateList.value) {
      print(vaccine.name);
    }
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
              rows: CustomRowVaccine().rowsVaccine(store.stateList.value),
            ),
          ),
        ),
      ),
    );
  }

  Future _getVaccines() async {
    await store.getList();
    if (store.error.value.isNotEmpty) {
      print('ERROR => ${store.error.value}');
    }
  }
}
