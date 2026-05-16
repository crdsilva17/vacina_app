import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

class CustomDataRow {

  List<DataRow> rowsVaccine(List<VaccineModel> vaccines) {
    return <DataRow>[
      for (var vaccine in vaccines)
        DataRow(
          cells: [
            DataCell(Center(child: Text(vaccine.id.toString()))),
            DataCell(Center(child: Text(vaccine.name))),
            DataCell(Center(child: Text(vaccine.manufacturer))),
            DataCell(Center(child: Text(vaccine.manufactureDate))),
            DataCell(Center(child: Text(vaccine.expiryDate))),
            DataCell(Center(child: Text(vaccine.lot))),
            DataCell(Center(child: Text(vaccine.minRecommendedAge.toString()))),
            DataCell(Center(child: Text(vaccine.maxRecommendedAge.toString()))),
            DataCell(Center(child: Text(vaccine.posto))),
            DataCell(Center(child: Text(vaccine.doses))),
            DataCell(Center(child: Text(vaccine.description))),
            DataCell(Center(child: Text(vaccine.stockQuantity.toString()))),
          ],
        ),
    ];
  }

  List<DataRow> rowsLocal(List<LocalModel> locals) {
    var local = locals;
    Map<String, int> idToIndex = {
      for (int i = 0; i < local.length; i++) local[i].id: i + 1,
    };
    return <DataRow>[
      for (var local in locals)
        DataRow(
          cells: [
            DataCell(Center(child: Text(idToIndex[local.id].toString()))),
            DataCell(Center(child: Text(local.name))),
            DataCell(Center(child: Text(local.numero),)),
            DataCell(Center(child: Text(local.rua))),
            DataCell(Center(child: Text(local.bairro))),
            DataCell(Center(child: Text(local.cidade))),
            DataCell(Center(child: Text(local.estado))),
            DataCell(Center(child: Text(local.cep))),
            DataCell(Center(child: Text(local.horarioFuncionamento))),
            DataCell(Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.edit)),)),
            DataCell(Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.delete)),))
          ],
        ),
    ];
  }
}
