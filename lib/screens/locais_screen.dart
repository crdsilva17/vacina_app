import 'package:flutter/material.dart';
import 'package:vacina_app/data/dto/local_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/address_model.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/repositories/address_repository.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/store/address_store.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:vacina_app/util/cep_input_formatter.dart';
import 'package:vacina_app/util/time_range_input_formatter.dart';
import 'package:vacina_app/widget/custom_data_column.dart';
import 'package:vacina_app/widget/custom_data_row.dart';
import 'package:vacina_app/widget/custom_new_row.dart';

class LocaisScreen extends StatefulWidget {
  const LocaisScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocaisScreenState();
}

class _LocaisScreenState extends State<LocaisScreen> {
  LocalStore localStore = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

  AddressStore addressStore = AddressStore(
    repository: AddressRepository(client: HttpClient()),
  );

  List<LocalModel> newLocal = List<LocalModel>.empty();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController horarioFuncionamentoController =
      TextEditingController();
  bool isNewRow = false;

  @override
  void dispose() {
    super.dispose();
  }

  var isEditing = <bool>[];

  bool insert = false;

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

  Widget _body() {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: CustomDataColumn().columnsLocal,
              rows: [
                ...CustomDataRow().rowsLocal(
                  context,
                  localStore.state.value,
                  isEditing,
                  _onDelete,
                  _onEdit,
                ),
                CustomNewRow().newRow(isNewRow, _onUpdate),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _onUpdate() async{
    setState(() {
      isNewRow = !isNewRow;
    });
  }
  void _onDelete(String id) async {
    await localStore.deleteLocal(id);
    setState(() {
      _getlocais();
    });
  }

  void _onEdit(int index, LocalModel e) async {
    if (isEditing[index]) {
      await localStore.updateLocal(e);
    }

    setState(() {
      if (isEditing[index]) {
        isEditing[index] = false;
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
        isEditing[index] = !isEditing[index];
      }
    });
  }

  DataRow _customRow() {
    return DataRow(
      cells: [
        DataCell(
          TextField(
            controller: nameController,
            readOnly: !insert,
            decoration: InputDecoration(
              hintText: insert ? 'nome' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
          ),
        ),
        DataCell(
          TextField(
            controller: numeroController,
            readOnly: !insert,
            decoration: InputDecoration(
              hintText: insert ? 'número' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        DataCell(
          TextField(
            controller: ruaController,
            readOnly: !insert,
            decoration: InputDecoration(
              hintText: insert ? 'rua' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
          ),
        ),
        DataCell(
          TextField(
            controller: bairroController,
            readOnly: !insert,
            decoration: InputDecoration(
              hintText: insert ? 'bairro' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
          ),
        ),
        DataCell(
          TextField(
            controller: cidadeController,
            readOnly: !insert,
            decoration: InputDecoration(
              hintText: insert ? 'cidade' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
          ),
        ),
        DataCell(
          TextField(
            controller: estadoController,
            readOnly: !insert,
            decoration: InputDecoration(
              hintText: insert ? 'estado' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
          ),
        ),
        DataCell(
          TextField(
            controller: cepController,
            decoration: InputDecoration(
              hintText: insert ? 'CEP' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [CepInputFormatter()],
            onChanged: (event) async {
              // Lógica para buscar o endereço com base no CEP
              if (cepController.text.length == 9) {
                await addressStore.fetchAddressByCep(cepController.text);
                AddressModel address = addressStore.state.value;
                setState(() {
                  ruaController.text = address.street;
                  bairroController.text = address.neighborhood;
                  cidadeController.text = address.city;
                  estadoController.text = address.state;
                });
              }
            },
          ),
        ),
        DataCell(
          TextField(
            controller: horarioFuncionamentoController,
            readOnly: !insert,
            decoration: InputDecoration(
              hintText: insert ? 'horário de funcionamento' : 'add',
              filled: insert,
              border: insert
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
            ),
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.center,
            inputFormatters: [TimeRangeInputFormatter()],
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(insert ? Icons.save : Icons.add),
            onPressed: () async {
              if (!insert) {
                setState(() {
                  insert = true;
                });
                return;
              }
              // Lógica para adicionar um novo local
              if (nameController.text.isEmpty ||
                  numeroController.text.isEmpty ||
                  ruaController.text.isEmpty ||
                  bairroController.text.isEmpty ||
                  cidadeController.text.isEmpty ||
                  estadoController.text.isEmpty ||
                  cepController.text.isEmpty ||
                  horarioFuncionamentoController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Preencha todos os campos para adicionar um novo local.',
                    ),
                  ),
                );
                return;
              }
              LocalRequest newLocalRequest = LocalRequest(
                name: nameController.text,
                numero: numeroController.text,
                rua: ruaController.text,
                bairro: bairroController.text,
                cidade: cidadeController.text,
                estado: estadoController.text,
                cep: cepController.text,
                horarioFuncionamento: horarioFuncionamentoController.text,
              );
              await localStore.createLocal(newLocalRequest);
              await _getlocais();
              setState(() {
                nameController.clear();
                numeroController.clear();
                ruaController.clear();
                bairroController.clear();
                cidadeController.clear();
                estadoController.clear();
                cepController.clear();
                horarioFuncionamentoController.clear();
                insert = false;
              });
            },
          ),
        ),
        DataCell(
          insert
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Lógica para cancelar a adição de um novo local
                    setState(() {
                      nameController.clear();
                      numeroController.clear();
                      ruaController.clear();
                      bairroController.clear();
                      cidadeController.clear();
                      estadoController.clear();
                      cepController.clear();
                      horarioFuncionamentoController.clear();
                      insert = false;
                    });
                  },
                )
              : const SizedBox(),
        ), // Célula vazia para o ícone de excluir
      ],
    );
  }
}
