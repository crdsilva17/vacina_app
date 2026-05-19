import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/address_model.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/util/cep_input_formatter.dart';
import 'package:vacina_app/util/time_range_input_formatter.dart';

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

  List<DataRow> rowsLocal(
    BuildContext context,
    Map<String, Map<String, TextEditingController>> controllers,
    List<LocalModel> locals,
    List<bool> isEditing,
    Function(String id) onDelete,
    Function(int index, LocalModel local) onEdit,
    Function(String event, String id) onGetCep,
  ) {
    Map<String, int> idToIndex = {
      for (int i = 0; i < controllers.length; i++)
        controllers.keys.elementAt(i): i + 1,
    };
    return <DataRow>[
      for (var entry in controllers.entries)
        DataRow(
          cells: [
            DataCell(Center(child: Text(idToIndex[entry.key].toString()))),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: entry.value['nome'],
                      )
                    : Text(entry.value['nome']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: entry.value['numero'],
                        keyboardType: TextInputType.number,
                      )
                    : Text(entry.value['numero']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: entry.value['rua'],
                      )
                    : Text(entry.value['rua']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: entry.value['bairro'],
                      )
                    : Text(entry.value['bairro']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: entry.value['cidade'],
                      )
                    : Text(entry.value['cidade']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: entry.value['estado'],
                      )
                    : Text(entry.value['estado']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        inputFormatters: [CepInputFormatter()],
                        keyboardType: TextInputType.number,
                        controller: entry.value['cep'],
                        onChanged: (event) async {
                          // Lógica para buscar o endereço com base no CEP
                          if (event.length == 9) {
                            await onGetCep(event, entry.key);
                          }
                        },
                      )
                    : Text(entry.value['cep']!.text),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[entry.key]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [TimeRangeInputFormatter()],
                        controller: entry.value['horario'],
                      )
                    : Text(entry.value['horario']!.text),
              ),
            ),
            DataCell(
              Center(
                child: IconButton(
                  onPressed: () {
                    if (isEditing[idToIndex[entry.key]! - 1]) {
                      LocalModel updatedLocal = LocalModel(
                        id: entry.key,
                        name: entry.value['nome']!.text,
                        numero: entry.value['numero']!.text,
                        rua: entry.value['rua']!.text,
                        bairro: entry.value['bairro']!.text,
                        cidade: entry.value['cidade']!.text,
                        estado: entry.value['estado']!.text,
                        cep: entry.value['cep']!.text,
                        horarioFuncionamento: entry.value['horario']!.text,
                      );
                      onEdit(idToIndex[entry.key]! - 1, updatedLocal);
                    } else {
                      var local = locals.firstWhere(
                        (element) => element.id == entry.key,
                      );
                      onEdit(idToIndex[entry.key]! - 1, local);
                    }
                  },
                  icon: Icon(
                    isEditing[idToIndex[entry.key]! - 1]
                        ? Icons.save
                        : Icons.edit,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Exclusão'),
                        content: const Text(
                          'Tem certeza de que deseja excluir este local?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              onDelete(entry.key);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Excluir'),
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
