import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/screens/store/local_store.dart';

class LocaisScreen extends StatefulWidget {
  const LocaisScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocaisScreenState();
}

class _LocaisScreenState extends State<LocaisScreen> {
  LocalStore localStore = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

  List<LocalModel> newLocal = List<LocalModel>.empty();

  @override
  void dispose() {
    super.dispose();
  }

  var isEditing = <bool>[];

  @override
  void initState() {
    super.initState();
    _getlocais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postos de Saúde'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),
      body: _body(),
    );
  }

  Future<void> _getlocais() async {
    try {
      await localStore.getLocal();
      setState(() {
        isEditing = List<bool>.filled(localStore.state.value.length, false);
        newLocal = List<LocalModel>.filled(
          localStore.state.value.length,
          LocalModel.empty(),
        );
      });
    } catch (e) {
      print('Erro ao obter locais: $e');
    }
  }

  SafeArea _body() {
    return SafeArea(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: _customColumns(), rows: _customRow()),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _customColumns() {
    return [
      const DataColumn(label: Text('Nome')),
      const DataColumn(label: Text('Numero')),
      const DataColumn(label: Text('Rua')),
      const DataColumn(label: Text('Bairro')),
      const DataColumn(label: Text('Cidade')),
      const DataColumn(label: Text('Estado')),
      const DataColumn(label: Text('CEP')),
      const DataColumn(label: Text('Horário de Funcionamento')),
      const DataColumn(label: Text('Editar')),
      const DataColumn(label: Text('Excluir')),
    ];
  }

  List<DataRow> _customRow() {
    var local = localStore.state.value;
    Map<String, int> idToIndex = {
      for (int i = 0; i < local.length; i++) local[i].id: i,
    };

    return local.map((e) {
      return DataRow(
        cells: [
          DataCell(
            isEditing[idToIndex[e.id]!]
                ? TextField(
                    controller: TextEditingController(text: e.name),
                    onChanged: (value) {
                      newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                          .copyWith(name: value);
                    },
                  )
                : Text(e.name),
          ),
          DataCell(
            Center(
              child: isEditing[idToIndex[e.id]!]
                  ? TextField(
                      controller: TextEditingController(text: e.numero),
                      onChanged: (value) {
                        newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                            .copyWith(numero: value);
                      },
                    )
                  : Text(e.numero),
            ),
          ),
          DataCell(
            isEditing[idToIndex[e.id]!]
                ? TextField(
                    controller: TextEditingController(text: e.rua),
                    onChanged: (value) {
                      newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                          .copyWith(rua: value);
                    },
                  )
                : Text(e.rua),
          ),
          DataCell(
            isEditing[idToIndex[e.id]!]
                ? TextField(
                    controller: TextEditingController(text: e.bairro),
                    onChanged: (value) {
                      newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                          .copyWith(bairro: value);
                    },
                  )
                : Text(e.bairro),
          ),
          DataCell(
            isEditing[idToIndex[e.id]!]
                ? TextField(
                    controller: TextEditingController(text: e.cidade),
                    onChanged: (value) {
                      newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                          .copyWith(cidade: value);
                    },
                  )
                : Text(e.cidade),
          ),
          DataCell(
            Center(
              child: isEditing[idToIndex[e.id]!]
                  ? TextField(
                      controller: TextEditingController(text: e.estado),
                      onChanged: (value) {
                        newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                            .copyWith(estado: value);
                      },
                    )
                  : Text(e.estado),
            ),
          ),
          DataCell(
            Center(
              child: isEditing[idToIndex[e.id]!]
                  ? TextField(
                      controller: TextEditingController(text: e.cep),
                      onChanged: (value) {
                        newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                            .copyWith(cep: value);
                      },
                    )
                  : Text(e.cep),
            ),
          ),
          DataCell(
            Center(
              child: isEditing[idToIndex[e.id]!]
                  ? TextField(
                      controller: TextEditingController(
                        text: e.horarioFuncionamento,
                      ),
                      onChanged: (value) {
                        newLocal[idToIndex[e.id]!] = newLocal[idToIndex[e.id]!]
                            .copyWith(horarioFuncionamento: value);
                      },
                    )
                  : Text(e.horarioFuncionamento),
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(isEditing[idToIndex[e.id]!] ? Icons.save : Icons.edit),
              onPressed: () {
                // Lógica para editar o local
                setState(() {
                  if (isEditing[idToIndex[e.id]!]) {
                    LocalModel updatedLocal = LocalModel(
                      id: newLocal[idToIndex[e.id]!].id.isEmpty
                          ? e.id
                          : newLocal[idToIndex[e.id]!].id,
                      name: newLocal[idToIndex[e.id]!].name.isEmpty
                          ? e.name
                          : newLocal[idToIndex[e.id]!].name,
                      numero: newLocal[idToIndex[e.id]!].numero.isEmpty
                          ? e.numero
                          : newLocal[idToIndex[e.id]!].numero,
                      rua: newLocal[idToIndex[e.id]!].rua.isEmpty
                          ? e.rua
                          : newLocal[idToIndex[e.id]!].rua,
                      bairro: newLocal[idToIndex[e.id]!].bairro.isEmpty
                          ? e.bairro
                          : newLocal[idToIndex[e.id]!].bairro,
                      cidade: newLocal[idToIndex[e.id]!].cidade.isEmpty
                          ? e.cidade
                          : newLocal[idToIndex[e.id]!].cidade,
                      estado: newLocal[idToIndex[e.id]!].estado.isEmpty
                          ? e.estado
                          : newLocal[idToIndex[e.id]!].estado,
                      cep: newLocal[idToIndex[e.id]!].cep.isEmpty
                          ? e.cep
                          : newLocal[idToIndex[e.id]!].cep,
                      horarioFuncionamento:
                          newLocal[idToIndex[e.id]!]
                              .horarioFuncionamento
                              .isEmpty
                          ? e.horarioFuncionamento
                          : newLocal[idToIndex[e.id]!].horarioFuncionamento,
                    );
                    localStore.updateLocal(updatedLocal);
                    local[idToIndex[e.id]!] = updatedLocal;
                    isEditing[idToIndex[e.id]!] = false;
                  } else if (isEditing.any((editing) => editing)) {
                    // Se já houver outro item em edição, não permita iniciar a edição de outro
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Finalize a edição atual antes de editar outro item.',
                        ),
                      ),
                    );
                  } else {
                    isEditing[idToIndex[e.id]!] = !isEditing[idToIndex[e.id]!];
                  }
                });
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Lógica para excluir o local
              },
            ),
          ),
        ],
      );
    }).toList();
  }
}
