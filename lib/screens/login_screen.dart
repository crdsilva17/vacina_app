import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/token_repository.dart';
import 'package:vacina_app/screens/account_screen.dart';
import 'package:vacina_app/screens/check_screen.dart';
import 'package:vacina_app/data/store/token_store.dart';
import 'package:vacina_app/util/custom_navigate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TokenStore token = TokenStore(
    repository: TokenRepository(client: HttpClient()),
  );
  var _maskPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue[600], body: _body());
  }

  Widget _body() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Icon(
                    Icons.vaccines_outlined,
                    size: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'IMUNE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 35),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: emailController,
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
                      SizedBox(height: 30),
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
                          controller: passwordController,
                          obscureText: _maskPass,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _logar,
                    child: const Text('Entrar'),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        push(context, AccountScreen());
                      },
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logar() async {
    if (_formKey.currentState!.validate()) {
      final String email = emailController.text;
      final String senha = passwordController.text;
      try {
        await token.getToken({'email': email, 'senha': senha});
      } catch (exception) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                exception.toString().replaceFirst("Exception: ", ""),
                style: TextStyle(
                  color: const Color.fromARGB(255, 244, 228, 16),
                ),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 215, 22, 9),
          ),
        );
        return;
      }
      setState(() {
        push(context, CheckScreen(), replace: true);
      });
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
    }
  }
}
