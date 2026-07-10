import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/dto/campanha_request.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:vacina_app/data/store/vaccine_store.dart';

// Importações fictícias - substitua pelos caminhos corretos do seu projeto
// import 'package:seu_app/stores/vaccine_store.dart';
// import 'package:seu_app/stores/local_store.dart';

class CampanhaFormScreen extends StatefulWidget {
  final CampanhaRequest? campanha;
  final VaccineStore vaccineStore; // Passe a instância da sua VaccineStore aqui
  final LocalStore localStore; // Passe a instância da sua LocalStore aqui

  const CampanhaFormScreen({
    super.key,
    this.campanha,
    required this.vaccineStore,
    required this.localStore,
  });

  @override
  State<CampanhaFormScreen> createState() => _CampanhaFormScreenState();
}

class _CampanhaFormScreenState extends State<CampanhaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat _apiFormatter = DateFormat('dd/MM/yyyy');

  // Controllers dos Inputs
  final _nomeController = TextEditingController();
  final _ageMinController = TextEditingController();
  final _ageMaxController = TextEditingController();

  // Estados de seleção
  String? _vacinaIdSelecionado;
  List<String> _localIdsSelecionados = [];
  DateTime? _dataInicioSelecionada;
  DateTime? _dataFimSelecionada;

  @override
  void initState() {
    super.initState();

    // Dispara a busca dos dados do banco ao abrir a tela
    widget.vaccineStore.getList();
    widget.localStore.getLocal();

    // Se for edição, popula o estado com os dados existentes da campanha
    if (widget.campanha != null) {
      final c = widget.campanha!;
      _nomeController.text = c.nome;
      _ageMinController.text = c.ageMin;
      _ageMaxController.text = c.ageMax;
      _vacinaIdSelecionado = c.vacinaId;
      _localIdsSelecionados = List<String>.from(c.localIds);
      _dataInicioSelecionada = _apiFormatter.parse(c.dataInicio);
      _dataFimSelecionada = _apiFormatter.parse(c.dataFim);
    }
  }

  Future<void> _selecionarData(BuildContext context, bool isInicio) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: isInicio
          ? (_dataInicioSelecionada ?? DateTime.now())
          : (_dataFimSelecionada ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (dataSelecionada != null) {
      setState(() {
        if (isInicio) {
          _dataInicioSelecionada = dataSelecionada;
        } else {
          _dataFimSelecionada = dataSelecionada;
        }
      });
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    if (_vacinaIdSelecionado == null) {
      _mostrarAlerta('Selecione uma vacina obrigatória.');
      return;
    }

    if (_localIdsSelecionados.isEmpty) {
      _mostrarAlerta('Selecione ao menos um local para a campanha.');
      return;
    }

    if (_dataInicioSelecionada == null || _dataFimSelecionada == null) {
      _mostrarAlerta('Determine o período de início e fim.');
      return;
    }

    final novaCampanha = CampanhaRequest(
      nome: _nomeController.text,
      vacinaId: _vacinaIdSelecionado!,
      localIds: _localIdsSelecionados,
      dataInicio: _apiFormatter.format(_dataInicioSelecionada!),
      dataFim: _apiFormatter.format(_dataFimSelecionada!),
      ageMin: _ageMinController.text.isEmpty ? '' : _ageMinController.text,
      ageMax: _ageMaxController.text.isEmpty ? '' : _ageMaxController.text,
    );

    Navigator.pop(context, novaCampanha);
  }

  void _mostrarAlerta(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.campanha != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Campanha' : 'Nova Campanha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 15),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Campanha *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // 1. SELECT DINÂMICO DE VACINAS (ValueNotifier: stateList)
              ValueListenableBuilder<List<dynamic>>(
                valueListenable: widget.vaccineStore.stateList,
                builder: (context, listaVacinas, child) {
                  if (listaVacinas.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: _vacinaIdSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Selecione a Vacina *',
                      border: OutlineInputBorder(),
                    ),
                    items: listaVacinas.map<DropdownMenuItem<String>>((vacina) {
                      return DropdownMenuItem<String>(
                        value: vacina
                            .id, // Garanta que sua classe de Vacina tenha a propriedade .id
                        child: Text(
                          vacina.name,
                        ), // Garanta que tenha a propriedade .nome
                      );
                    }).toList(),
                    onChanged: (novoId) {
                      setState(() {
                        _vacinaIdSelecionado = novoId;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Seleção obrigatória' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // SELETORES DE DATA
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selecionarData(context, true),
                      label: Text(
                        _dataInicioSelecionada == null
                            ? 'Data Início *'
                            : 'Início: ${_apiFormatter.format(_dataInicioSelecionada!)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selecionarData(context, false),
                      label: Text(
                        _dataFimSelecionada == null
                            ? 'Data Fim *'
                            : 'Fim: ${_apiFormatter.format(_dataFimSelecionada!)}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageMinController,
                      decoration: const InputDecoration(
                        labelText: 'Idade Mínima',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _ageMaxController,
                      decoration: const InputDecoration(
                        labelText: 'Idade Máxima',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. CHECKBOXES DOS POSTOS / LOCAIS (ValueNotifier: state)
              const Text(
                'Selecione os Locais de Atendimento *',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                height:
                    200, // Limita o tamanho para rolar caso existam dezenas de postos
                child: ValueListenableBuilder<List<dynamic>>(
                  valueListenable: widget.localStore.state,
                  builder: (context, listaLocais, child) {
                    if (listaLocais.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: listaLocais.length,
                      itemBuilder: (context, index) {
                        final local =
                            listaLocais[index]; // Objeto da sua LocalStore
                        final bool estaSelecionado = _localIdsSelecionados
                            .contains(local.id);

                        return CheckboxListTile(
                          title: Text(
                            local.name,
                          ), // Adapte para a propriedade de nome do seu objeto local
                          value: estaSelecionado,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? valor) {
                            setState(() {
                              if (valor == true) {
                                _localIdsSelecionados.add(local.id);
                              } else {
                                _localIdsSelecionados.remove(local.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  isEdicao ? 'Salvar Alterações' : 'Cadastrar Campanha',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
