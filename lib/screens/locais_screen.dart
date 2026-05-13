import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/screens/store/local_store.dart';

class LocaisScreen extends StatefulWidget {
  const LocaisScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocaisScreenState();
}

class _LocaisScreenState extends State<LocaisScreen> {
  final LocalStore localStore = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

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
            isEditing[idToIndex[e.id]!] ? TextField(
              controller: TextEditingController(text: e.name),
              onSubmitted: (newValue) {
                setState(() {});
              },
            ) : Text(e.name),
          ),
          DataCell(Center(child: isEditing[idToIndex[e.id]!] ? TextField(
            controller: TextEditingController(text: e.numero),
            onSubmitted: (newValue) {
              setState(() {});
            },
          ) : Text(e.numero))),
          DataCell(isEditing[idToIndex[e.id]!] ? TextField(
            controller: TextEditingController(text: e.rua),
            onSubmitted: (newValue) {
              setState(() {});
            },
          ) : Text(e.rua)),
          DataCell(isEditing[idToIndex[e.id]!] ? TextField(
            controller: TextEditingController(text: e.bairro),
            onSubmitted: (newValue) {
              setState(() {});
            },
          ) : Text(e.bairro)),
          DataCell(isEditing[idToIndex[e.id]!] ? TextField(
            controller: TextEditingController(text: e.cidade),
            onSubmitted: (newValue) {
              setState(() {});
            },
          ) : Text(e.cidade)),
          DataCell(Center(child: isEditing[idToIndex[e.id]!] ? TextField(
            controller: TextEditingController(text: e.estado),
            onSubmitted: (newValue) {
              setState(() {});
            },
          ) : Text(e.estado))),
          DataCell(Center(child: isEditing[idToIndex[e.id]!] ? TextField(
            controller: TextEditingController(text: e.cep),
            onSubmitted: (newValue) {
              setState(() {});
            },
          ) : Text(e.cep))),
          DataCell(Center(child: isEditing[idToIndex[e.id]!] ? TextField(
            controller: TextEditingController(text: e.horarioFuncionamento),
            onSubmitted: (newValue) {
              setState(() {});
            },
          ) : Text(e.horarioFuncionamento))),
          DataCell(
            IconButton(
              icon: Icon(isEditing[idToIndex[e.id]!] ? Icons.save : Icons.edit),
              onPressed: () {
                // Lógica para editar o local
                setState(() {
                  isEditing[idToIndex[e.id]!] = !isEditing[idToIndex[e.id]!];
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
