import 'package:flutter/material.dart';
import 'package:vacina_app/data/dto/vaccine_request.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

class CustomRowVaccine {
  List<DataRow> rowsVaccine(
    BuildContext context,
    List<VaccineModel> vaccines,
    Map<String, Map<String, TextEditingController>> controllers,
    List<bool> isEditing,
    Function(String id) onDelete,
    Function(String id, VaccineRequest vaccine) onUpdate,
    Function() setState,
    Function(TextEditingController edit) setDate,
    Function(TextEditingController controller) getLocalId,
  ) {
    Map<String, int> idToIndex = {
      for (var i = 0; i < controllers.length; i++)
        controllers.keys.elementAt(i): i,
    };

    Widget btnDelete(MapEntry entry) {
      return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(entry.key == 'add_new' ? 'Cancelar' : 'Excluir'),
              content: Text(
                entry.key == 'add_new'
                    ? 'Deseja cancelar a edição?'
                    : 'Deseja excluir a vacina "${entry.value['name']!.text}"?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(entry.key == 'add_new' ? 'Não' : 'Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (entry.key == 'add_new') {
                      isEditing[idToIndex[entry.key]!] = false;
                      setState();
                      return;
                    }
                    onDelete(entry.key);
                  },
                  child: Text(entry.key == 'add_new' ? 'Sim' : 'Confirmar'),
                ),
              ],
            ),
          );
        },
        icon: Icon(Icons.delete),
      );
    }

    return <DataRow>[
      for (var entry in controllers.entries)
        DataRow(
          cells: [
            DataCell(
              Center(
                child: Text(
                  entry.key == 'add_new'
                      ? 'Auto'
                      : idToIndex[entry.key].toString(),
                ),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['name'])
                    : Text(entry.value['name']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['manufacturer'])
                    : Text(entry.value['manufacturer']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(
                        controller: entry.value['manufactureDate'],
                        readOnly: true,
                        onTap: () {
                          setDate(entry.value['manufactureDate']!);
                        },
                      )
                    : Text(entry.value['manufactureDate']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(
                        controller: entry.value['expiryDate'],
                        readOnly: true,
                        onTap: () {
                          setDate(entry.value['expiryDate']!);
                        },
                      )
                    : Text(entry.value['expiryDate']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['lot'])
                    : Text(entry.value['lot']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['minRecommendedAge'])
                    : Text(entry.value['minRecommendedAge']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['maxRecommendedAge'])
                    : Text(entry.value['maxRecommendedAge']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(
                        controller: entry.value['posto'],
                        readOnly: true,
                        onTap: () {
                          getLocalId(entry.value['posto']!);
                        },
                      )
                    : Text(entry.value['posto']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['doses'])
                    : Text(entry.value['doses']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['description'])
                    : Text(entry.value['description']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]!]
                    ? TextField(controller: entry.value['stockQuantity'])
                    : Text(entry.value['stockQuantity']!.text),
              ),
            ),
            DataCell(
              Center(
                child: IconButton(
                  onPressed: () {
                    if (!isEditing[idToIndex[entry.key]!]) {
                      isEditing[idToIndex[entry.key]!] = true;
                      setState();
                      return;
                    }
                    if (isEditing[idToIndex[entry.key]!]) {
                      VaccineRequest request = VaccineRequest.fromMapEntry(
                        entry,
                      );

                      onUpdate(entry.key, request);
                      isEditing[idToIndex[entry.key]!] = false;
                    }
                  },
                  icon: Icon(
                    isEditing[idToIndex[entry.key]!]
                        ? Icons.save
                        : entry.key == 'add_new'
                        ? Icons.add
                        : Icons.edit,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: entry.key == 'add_new'
                    ? isEditing[idToIndex[entry.key]!]
                          ? btnDelete(entry)
                          : Text('')
                    : btnDelete(entry),
              ),
            ),
          ],
        ),
    ];
  }
}
