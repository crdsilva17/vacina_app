import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

class CustomRowVaccine {
  List<DataRow> rowsVaccine(
    List<VaccineModel> vaccines,
    Map<String, Map<String, TextEditingController>> controllers,
    List<bool> isEditing,
  ) {
    Map<String, int> idToIndex = {
      for (var i = 0; i < controllers.length; i++)
        controllers.keys.elementAt(i): i,
    };
    return <DataRow>[
      for (var vaccine in vaccines)
        DataRow(
          cells: [
            DataCell(Center(child: Text(idToIndex[vaccine.id].toString()))),
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
            DataCell(
              Center(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              ),
            ),
            DataCell(
              Center(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              ),
            ),
          ],
        ),
    ];
  }
}
