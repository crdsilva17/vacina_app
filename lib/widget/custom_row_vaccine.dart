import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

class CustomRowVaccine {
  List<DataRow> rowsVaccine(
    BuildContext context,
    List<VaccineModel> vaccines,
    Map<String, Map<String, TextEditingController>> controllers,
    List<bool> isEditing,
    Function(String id) onDelete,
  ) {
    Map<String, int> idToIndex = {
      for (var i = 0; i < controllers.length; i++)
        controllers.keys.elementAt(i): i,
    };
    return <DataRow>[
      for (var entry in controllers.entries)
        DataRow(
          cells: [
            DataCell(Center(child: Text(idToIndex[entry.key].toString()))),
            DataCell(Center(child: Text(entry.value['name']!.text))),
            DataCell(Center(child: Text(entry.value['manufacturer']!.text))),
            DataCell(Center(child: Text(entry.value['manufactureDate']!.text))),
            DataCell(Center(child: Text(entry.value['expiryDate']!.text))),
            DataCell(Center(child: Text(entry.value['lot']!.text))),
            DataCell(
              Center(child: Text(entry.value['minRecommendedAge']!.text)),
            ),
            DataCell(
              Center(child: Text(entry.value['maxRecommendedAge']!.text)),
            ),
            DataCell(Center(child: Text(entry.value['posto']!.text))),
            DataCell(Center(child: Text(entry.value['doses']!.text))),
            DataCell(Center(child: Text(entry.value['description']!.text))),
            DataCell(Center(child: Text(entry.value['stockQuantity']!.text))),
            DataCell(
              Center(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              ),
            ),
            DataCell(
              Center(
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Excluir'),
                        content: Text(
                          'Deseja excluir a vacina "${entry.value['name']!.text}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onDelete(entry.key);
                            },
                            child: Text('Confirmar'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
    ];
  }
}
