import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vacina_app/data/dto/register_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/repositories/users_repository.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/store/users_store.dart';
import 'package:vacina_app/screens/login_screen.dart';
import 'package:vacina_app/util/custom_navigate.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final LocalStore store = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

  final UsersStore usersStore = UsersStore(
    repository: UsersRepository(client: HttpClient()),
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
  final TextEditingController senhaConfirmEditController =
      TextEditingController();
  final dropValue = ValueNotifier('');
  final dropOptions = [''];
  final dropOptionsId = [''];
  final double spacing = 30;
  var _maskPass = true;
  var _maskConfirmPass = true;

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
        backgroundColor: Colors.blue[900],
      ),
      body: _body(),
    );
  }

  Widget? _body() {
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
                child: TextField(
                  controller: nomeEditController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              // Field for input CPF
              SizedBox(
                child: TextFormField(
                  controller: cpfEditController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfFormatter],
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              // Field for date of birth
              SizedBox(
                child: TextField(
                  controller: dataNscEditController,
                  decoration: InputDecoration(
                    label: Text('Data de Nascimento'),
                    prefixIcon: Icon(Icons.badge_outlined, color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
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
                        postoEditController.text = dropValue.value,
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
                child: TextFormField(
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailEditController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um e-mail';
                    }
                    // Expressão regular simples para validar e-mail
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Insira um e-mail válido';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: spacing),
              // Field for password
              SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _maskPass = !_maskPass;
                        });
                      },
                      icon: Icon(
                        _maskPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    String pattern =
                        r'^^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[$*&@#])[0-9a-zA-Z$*&@#]{8,}$$';
                    RegExp regex = RegExp(pattern);
                    if (value == null || !regex.hasMatch(value)) {
                      return 'Sua senha deve conter no minimo 8 caracteres\nUma letra maiuscula\nUma letra minuscula\nUm caracter especial.';
                    }
                    return null;
                  },
                  controller: senhaEditController,
                  obscureText: _maskPass,
                ),
              ),

              SizedBox(height: spacing),
              // Field for confirm password
              SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _maskConfirmPass = !_maskConfirmPass;
                        });
                      },
                      icon: Icon(
                        _maskConfirmPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    String pattern =
                        r'^^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[$*&@#])[0-9a-zA-Z$*&@#]{8,}$$';
                    RegExp regex = RegExp(pattern);
                    if (value == null || !regex.hasMatch(value)) {
                      return 'Sua senha deve conter no minimo 8 caracteres\nUma letra maiuscula\nUma letra minuscula\nUm caracter especial.';
                    } else if (value != senhaEditController.text) {
                      return 'Os valores de senha e confirmação \ndevem ser iguais!';
                    }
                    return null;
                  },
                  controller: senhaConfirmEditController,
                  obscureText: _maskConfirmPass,
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
                  onPressed: () async {
                    if (senhaConfirmEditController.text !=
                        senhaEditController.text) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Valor da senha diferente!')),
                      );
                      return;
                    }
                    Map<String, dynamic> map = {
                      'name': nomeEditController.text,
                      'cpf': cpfEditController.text,
                      'dataNsc': dataNscEditController.text,
                      'localId': postoEditController.text,
                      'email': emailEditController.text,
                      'passwd': senhaEditController.text,
                    };
                    RegisterRequest register = RegisterRequest.fromMap(map);
                    await usersStore.registerUser(register);

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          usersStore.state.value.email.isNotEmpty
                              ? 'Usuario Cadastrado com sucesso!'
                              : usersStore.error.value,
                        ),
                      ),
                    );
                    if (usersStore.state.value.email.isNotEmpty) {
                      push(context, LoginScreen(), replace: true);
                    }
                  },
                  child: const Text('Cadastrar'),
                ),
              ),
              SizedBox(height: 40.0),
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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        final formatter = DateFormat('dd/MM/yyyy');
        dataNscEditController.text = formatter.format(picked);
      });
    }
  }
}
