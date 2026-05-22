import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

class CustomRowVaccine {
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
}
