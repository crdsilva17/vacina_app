import 'package:flutter/material.dart';
import 'package:vacina_app/data/dto/local_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/address_model.dart';
import 'package:vacina_app/data/repositories/address_repository.dart';
import 'package:vacina_app/data/store/address_store.dart';
import 'package:vacina_app/util/cep_input_formatter.dart';
import 'package:vacina_app/util/time_range_input_formatter.dart';

class CustomNewRow {
  AddressStore addressStore = AddressStore(
    repository: AddressRepository(client: HttpClient()),
  );

  DataRow newRow(
    BuildContext context,
    Map<String, Map<String, TextEditingController>> controllers,
    bool isEditing,
    Function(bool rep) onUpdate,
    Function(LocalRequest newLocal) onCreate,
    Function(String event, String id) onGetCpf,
  ) {
    if (isEditing) {
      controllers.addAll({
        "new": {
          'nome': TextEditingController(),
          'rua': TextEditingController(),
          'numero': TextEditingController(),
          'bairro': TextEditingController(),
          'cidade': TextEditingController(),
          'estado': TextEditingController(),
          'cep': TextEditingController(),
          'horario': TextEditingController(),
        },
      });
    }
    var entry = controllers.entries.isNotEmpty
        ? controllers.entries.last
        : null;

    return DataRow(
      cells: [
        DataCell(Center(child: isEditing ? Text('Auto') : Text('new'))),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['nome'],
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'nome',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['numero'],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'numero',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['rua'],
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'rua',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['bairro'],
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'bairro',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['cidade'],
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'cidade',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['estado'],
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'estado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['cep'],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'cep',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      inputFormatters: [CepInputFormatter()],
                      onChanged: (event) async {
                        // Lógica para buscar o endereço com base no CEP
                        if (event.length == 9) {
                          onGetCpf(event, entry!.key);
                          onUpdate(false);
                        }
                      },
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: entry?.value['horario'],
                      inputFormatters: [TimeRangeInputFormatter()],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'horario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(
          Center(
            child: IconButton(
              onPressed: () {
                if (!isEditing) {
                  onUpdate(true);
                  return;
                }
                if (entry!.value['nome']!.text.isEmpty ||
                    entry.value['rua']!.text.isEmpty ||
                    entry.value['numero']!.text.isEmpty ||
                    entry.value['bairro']!.text.isEmpty ||
                    entry.value['cidade']!.text.isEmpty ||
                    entry.value['estado']!.text.isEmpty ||
                    entry.value['cep']!.text.isEmpty ||
                    entry.value['horario']!.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Preencha todos os campos antes de salvar!',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  );
                  return;
                }
                LocalRequest newLocal = LocalRequest(
                  name: entry.value['name']!.text,
                  rua: entry.value['rua']!.text,
                  numero: entry.value['numero']!.text,
                  bairro: entry.value['bairro']!.text,
                  cidade: entry.value['cidade']!.text,
                  estado: entry.value['estado']!.text,
                  cep: entry.value['cep']!.text,
                  horarioFuncionamento: entry.value['horario']!.text,
                );
                onCreate(newLocal);
              },
              icon: isEditing ? Icon(Icons.save) : Icon(Icons.add),
            ),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Encerrar nova adição!'),
                          content: const Text('Deseja encerrar a nova adição?'),
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
                                onUpdate(true);
                              },
                              child: Text('Confirmar'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.delete),
                  )
                : Text(''),
          ),
        ),
      ],
    );
  }
}
