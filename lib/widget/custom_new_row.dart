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
  final TextEditingController name;
  final TextEditingController rua;
  final TextEditingController numero;
  final TextEditingController bairro;
  final TextEditingController cidade;
  final TextEditingController estado;
  final TextEditingController cep;
  final TextEditingController horario;

  CustomNewRow({
    required this.name,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.horario,
  });

  DataRow newRow(
    BuildContext context,
    bool isEditing,
    Function(bool rep) onUpdate,
    Function(LocalRequest newLocal) onCreate,
  ) {
    return DataRow(
      cells: [
        DataCell(Center(child: isEditing ? Text('Auto') : Text('new'))),
        DataCell(
          Center(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: name,
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
                      controller: numero,
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
                      controller: rua,
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
                      controller: bairro,
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
                      controller: cidade,
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
                      controller: estado,
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
                      controller: cep,
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
                          await addressStore.fetchAddressByCep(event);
                          AddressModel address = addressStore.state.value;
                          rua.text = address.street;
                          bairro.text = address.neighborhood;
                          cidade.text = address.city;
                          estado.text = address.state;
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
                      controller: horario,
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
                if (name.text.isEmpty ||
                    rua.text.isEmpty ||
                    numero.text.isEmpty ||
                    bairro.text.isEmpty ||
                    cidade.text.isEmpty ||
                    estado.text.isEmpty ||
                    cep.text.isEmpty ||
                    horario.text.isEmpty) {
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
                  name: name.text,
                  rua: rua.text,
                  numero: numero.text,
                  bairro: bairro.text,
                  cidade: cidade.text,
                  estado: estado.text,
                  cep: cep.text,
                  horarioFuncionamento: horario.text,
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
