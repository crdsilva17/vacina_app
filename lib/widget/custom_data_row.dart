import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/util/cep_input_formatter.dart';
import 'package:vacina_app/util/time_range_input_formatter.dart';
import 'package:vacina_app/widget/custom_new_row.dart';

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
    List<LocalModel> locals,
    List<bool> isEditing,
    Function(String id) onDelete,
    Function(int index, LocalModel local) onEdit,
  ) {
    var local = locals;
    TextEditingController nameController = TextEditingController();
    TextEditingController numeroController = TextEditingController();
    TextEditingController ruaController = TextEditingController();
    TextEditingController bairroController = TextEditingController();
    TextEditingController cidadeController = TextEditingController();
    TextEditingController estadoController = TextEditingController();
    TextEditingController cepController = TextEditingController();
    TextEditingController horarioFuncionamentoController =
        TextEditingController();

    Map<String, int> idToIndex = {
      for (int i = 0; i < local.length; i++) local[i].id: i + 1,
    };
    return <DataRow>[
      for (var local in locals)
        DataRow(
          cells: [
            DataCell(Center(child: Text(idToIndex[local.id].toString()))),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: nameController..text = local.name,
                      )
                    : Text(local.name),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: numeroController..text = local.numero,
                        keyboardType: TextInputType.number,
                      )
                    : Text(local.numero),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: ruaController..text = local.rua,
                      )
                    : Text(local.rua),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: bairroController..text = local.bairro,
                      )
                    : Text(local.bairro),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: cidadeController..text = local.cidade,
                      )
                    : Text(local.cidade),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        controller: estadoController..text = local.estado,
                      )
                    : Text(local.estado),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        inputFormatters: [CepInputFormatter()],
                        keyboardType: TextInputType.number,
                        controller: cepController..text = local.cep,
                      )
                    : Text(local.cep),
              ),
            ),
            DataCell(
              Center(
                child: isEditing[idToIndex[local.id]! - 1]
                    ? TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [TimeRangeInputFormatter()],
                        controller: horarioFuncionamentoController
                          ..text = local.horarioFuncionamento,
                      )
                    : Text(local.horarioFuncionamento),
              ),
            ),
            DataCell(
              Center(
                child: IconButton(
                  onPressed: () {
                    if (isEditing[idToIndex[local.id]! - 1]) {
                      LocalModel updatedLocal = LocalModel(
                        id: local.id,
                        name: nameController.text,
                        numero: numeroController.text,
                        rua: ruaController.text,
                        bairro: bairroController.text,
                        cidade: cidadeController.text,
                        estado: estadoController.text,
                        cep: cepController.text,
                        horarioFuncionamento:
                            horarioFuncionamentoController.text,
                      );
                      onEdit(idToIndex[local.id]! - 1, updatedLocal);
                    } else {
                      onEdit(idToIndex[local.id]! - 1, local);
                    }
                  },
                  icon: Icon(
                    isEditing[idToIndex[local.id]! - 1]
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
                              onDelete(local.id);
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
