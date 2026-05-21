import 'package:flutter/material.dart';
import 'package:vacina_app/data/dto/local_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/address_model.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/repositories/address_repository.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/store/address_store.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:vacina_app/widget/custom_data_column.dart';
import 'package:vacina_app/widget/custom_data_row.dart';

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
  Map<String, Map<String, TextEditingController>> controllers = {};

  bool isNewRow = false;

  String? _idEdit;

  @override
  void dispose() {
    for (var controller in controllers.entries) {
      for (var item in controller.value.entries) {
        item.value.dispose();
      }
    }
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
      initializeControllers(localStore.state.value);
      setState(() {
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: CustomDataColumn().columnsLocal,
                rows: [
                  ...CustomDataRow().rowsLocal(
                    context,
                    _idEdit,
                    controllers,
                    localStore.state.value,
                    isEditing,
                    _onDelete,
                    _onEdit,
                    _onCreate,
                    _onUpdate,
                    _onGetCep,
                  ) /*
                  CustomNewRow().newRow(
                    context,
                    controllers.values.last,
                    isNewRow,
                    _onUpdate,
                    _onCreate,
                    _onGetCep,
                    _onNew,
                  ),*/,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onUpdate(bool replace) {
    setState(() {
      if (replace) {
        isNewRow = !isNewRow;
        // Limpar linha nova
      }
    });
  }

  void initializeControllers(List<LocalModel> locals) {
    controllers.clear();
    for (var local in locals) {
      controllers[local.id] = {
        'nome': TextEditingController(text: local.name),
        'rua': TextEditingController(text: local.rua),
        'numero': TextEditingController(text: local.numero),
        'bairro': TextEditingController(text: local.bairro),
        'cidade': TextEditingController(text: local.cidade),
        'estado': TextEditingController(text: local.estado),
        'cep': TextEditingController(text: local.cep),
        'horario': TextEditingController(text: local.horarioFuncionamento),
      };
    }
    controllers["new"] = {
      'nome': TextEditingController(text: 'new'),
      'rua': TextEditingController(text: 'new'),
      'numero': TextEditingController(text: 'new'),
      'bairro': TextEditingController(text: 'new'),
      'cidade': TextEditingController(text: 'new'),
      'estado': TextEditingController(text: 'new'),
      'cep': TextEditingController(text: 'new'),
      'horario': TextEditingController(text: 'new'),
    };
    for (var i = 0; i < controllers.length; i++) {
      isEditing.add(false);
    }
  }

  void _onGetCep(String event, String id) async {
    if (event.length == 9) {
      await addressStore.fetchAddressByCep(event);
      AddressModel addressModel = addressStore.state.value;
      var entry = controllers.entries.firstWhere(
        (element) => element.key == id,
      );
      entry.value['rua']!.text = addressModel.street;
      entry.value['bairro']!.text = addressModel.neighborhood;
      entry.value['cidade']!.text = addressModel.city;
      entry.value['estado']!.text = addressModel.state;
    }
  }

  void _onCreate(LocalRequest newLocalRequest) async {
    if (newLocalRequest.isEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos antes de salvar!'),
        ),
      );
      return;
    }
    await localStore.createLocal(newLocalRequest);
    await _getlocais();
    _onUpdate(true);
  }

  void _onDelete(String id) async {
    await localStore.deleteLocal(id);
    setState(() {
      controllers.remove(id);
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
        return;
      } else {
        isEditing[index] = !isEditing[index];
        _idEdit = e.id;
      }
    });
    setFocus('cep', e.id);
  }

  void setFocus(String controller, String id) {
    final myController = controllers[id]?[controller];

    if (myController != null) {
      // Força o cursor para o final do texto do CEP
      myController.value = myController.value.copyWith(
        text: myController.text,
        selection: TextSelection.collapsed(offset: myController.text.length),
      );
    }
  }
}
