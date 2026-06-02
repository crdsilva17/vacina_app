import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/store/local_store.dart';

class ChangeNamePage extends StatefulWidget {
  final String currentName;
  final String currentDate;
  final String currentUBS;

  const ChangeNamePage({
    super.key,
    required this.currentName,
    required this.currentDate,
    required this.currentUBS,
  });

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  late TextEditingController controllerName;
  late TextEditingController controllerDate;
  late TextEditingController controllerUBS;
  final _formKey = GlobalKey<FormState>();
  final dropOptions = [''];
  final dropOptionsId = [''];
  final dropValue = ValueNotifier('');

  final LocalStore store = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController(text: widget.currentName);
    controllerDate = TextEditingController(text: widget.currentDate);
    controllerUBS = TextEditingController(text: widget.currentUBS);
    _getlocalId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerName,
                    validator: (value) {
                      if (value == null) {
                        return 'Insira seu nome.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controllerDate,
                    validator: (value) {
                      if (controllerDate.text.isEmpty ||
                          controllerDate.text.length < 10) {
                        return 'Data Inválida.';
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () {
                      _setDate(controllerDate.text);
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: dropValue,
                    builder: (BuildContext context, String value, _) {
                      if (dropOptions.contains(controllerUBS.text)) {
                        return SizedBox(
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null) {
                                return 'Selecione a sua UBS';
                              }
                              return null;
                            },
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.medical_services_outlined),
                            ),
                            initialValue: controllerUBS.text,
                            onChanged: (option) => {
                              dropValue.value = option.toString(),
                              controllerUBS.text = dropValue.value,
                            },
                            items: dropOptions
                                .map(
                                  (op) => DropdownMenuItem(
                                    value: op,
                                    child: Text(op),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
    }
  }

  Future<void> _getlocalId() async {
    await store.getLocal();
    dropOptions.clear();
    dropOptionsId.clear();
    for (var val in store.state.value) {
      dropOptions.add(val.name);
      dropOptionsId.add(val.id);
      dropValue.value = val.name;
    }
  }

  Future<void> _setDate(String date) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').parse(date),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        final formatter = DateFormat('dd/MM/yyyy');
        controllerDate.text = formatter.format(picked);
      });
    }
  }
}
