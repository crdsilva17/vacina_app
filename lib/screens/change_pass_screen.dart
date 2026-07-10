import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/users_repository.dart';
import 'package:vacina_app/data/store/users_store.dart';

class ChangePassScreen extends StatefulWidget {
  final String email;
  const ChangePassScreen({super.key, required this.email});

  @override
  State<StatefulWidget> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final TextEditingController passAtual = TextEditingController();
  final TextEditingController passNova = TextEditingController();
  final TextEditingController passConfirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final UsersStore usersStore = UsersStore(
    repository: UsersRepository(client: HttpClient()),
  );

  var _maskPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Senha'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SizedBox(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha Atual',
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
                      controller: passAtual,
                      obscureText: _maskPass,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nova Senha',
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
                      controller: passNova,
                      obscureText: _maskPass,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmação de Senha',
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
                        if (value == null || value != passNova.text) {
                          return 'Confirmação de Senha inválida.\nAs senhas informadas são diferentes.';
                        }
                        return null;
                      },
                      controller: passConfirm,
                      obscureText: _maskPass,
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        Map<String, String> map = {
                          'email': widget.email,
                          'oldPassword': passAtual.text,
                          'newPassword': passNova.text,
                        };

                        await usersStore.changePassword(map);

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                usersStore.state.value.email.isNotEmpty
                                    ? 'Senha alterada!'
                                    : usersStore.error.value,
                                style: TextStyle(
                                  color: usersStore.state.value.email.isNotEmpty
                                      ? const Color.fromARGB(255, 117, 239, 121)
                                      : const Color.fromARGB(255, 255, 255, 9),
                                ),
                              ),
                            ),
                            backgroundColor:
                                usersStore.state.value.email.isNotEmpty
                                ? const Color.fromARGB(255, 2, 121, 6)
                                : const Color.fromARGB(255, 255, 23, 6),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Confirmar'),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
