import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/screens/store/local_store.dart';
import 'package:vacina_app/widget/custom_text_field.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final LocalStore store = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );
  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final TextEditingController nomeEditController = TextEditingController();
  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController cpfEditController = TextEditingController();
  final TextEditingController dataNscEditController = TextEditingController();
  final TextEditingController postoEditController = TextEditingController();
  final TextEditingController senhaEditController = TextEditingController();
  final dropValue = ValueNotifier('');
  final dropOptions = [''];
  final dropOptionsId = [''];
  final double spacing = 30;

  @override
  void initState() {
    super.initState();
    _getlocalId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      body: _body(),
    );
  }

  Center _body() {
    _getlocalId();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: spacing),
              // Field for input name
              SizedBox(
                child: CustomTextField(
                  label: 'Nome',
                  icon: Icons.person_outlined,
                  controller: nomeEditController,
                  colorBorder: Colors.black,
                  colorIcon: Colors.black,
                  colorLabel: Colors.black,
                  colorText: Colors.black,
                  colorBorderSide: Colors.black,
                ),
              ),
              SizedBox(height: spacing),
              // Field for input CPF
              SizedBox(
                child: CustomTextField(
                  label: 'CPF',
                  icon: Icons.badge_outlined,
                  controller: cpfEditController,
                  keyBoardType: TextInputType.number,
                  inputFormatter: [cpfFormatter],
                  colorBorder: Colors.black,
                  colorIcon: Colors.black,
                  colorLabel: Colors.black,
                  colorText: Colors.black,
                  colorBorderSide: Colors.black,
                ),
              ),
              SizedBox(height: spacing),
              // Field for date of birth
              SizedBox(
                child: TextField(
                  controller: dataNscEditController,
                  decoration: InputDecoration(
                    label: Text('Data de Nascimento'),
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _setDate();
                  },
                ),
              ),
              SizedBox(height: spacing),
              // field for list of local
              ValueListenableBuilder(
                valueListenable: dropValue,
                builder: (BuildContext context, String value, _) {
                  return SizedBox(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        label: const Text('Posto de Saúde'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.medical_services_outlined),
                      ),
                      initialValue: null,
                      onChanged: (option) => {
                        dropValue.value = option.toString(),
                      },
                      items: dropOptions
                          .map(
                            (op) =>
                                DropdownMenuItem(value: op, child: Text(op)),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
              SizedBox(height: spacing),
              // Field for input e-mail
              SizedBox(
                child: CustomTextField(
                  label: 'E-mail',
                  icon: Icons.email_outlined,
                  controller: emailEditController,
                  colorBorder: Colors.black,
                  colorIcon: Colors.black,
                  colorLabel: Colors.black,
                  colorText: Colors.black,
                  colorBorderSide: Colors.black,
                ),
              ),

              SizedBox(height: spacing),
              // Field for password
              SizedBox(
                child:CustomTextField(
                      label: 'Senha',
                      icon: Icons.password_outlined,
                      controller: senhaEditController,
                      colorBorder: Colors.black,
                      colorIcon: Colors.black,
                      colorLabel: Colors.black,
                      colorText: Colors.black,
                      colorBorderSide: Colors.black,
                      isPassword: true,
                    ),
                ),
              SizedBox(height: spacing * 2),
              // Button for send register
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blueAccent, Colors.blue],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _setDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)
    );

    if (_picked != null) {
      setState(() {
        final formatter = DateFormat('dd/MM/yyyy');
        dataNscEditController.text = formatter.format(_picked);
      });
    }
  }
}
