import 'package:flutter/material.dart';
import 'package:vacina_app/screens/account_screen.dart';
import 'package:vacina_app/util/custom_navigate.dart';

import '../widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Container _body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0F),
            Color(0xFF0A0A0F),
            Color(0xFF1B263B),
            Color(0xFF415A77),
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 120, child: Placeholder()),
                const SizedBox(height: 16),
                const Text(
                  'IMUNE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 35),

                CustomTextField(
                  label: 'E-mail',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  colorBorder: Colors.white,
                  colorBorderSide: Colors.white70,
                  colorIcon: Colors.white,
                  colorLabel: Colors.white,
                  colorText: Colors.white,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  colorBorder: Colors.white,
                  colorBorderSide: Colors.white70,
                  colorIcon: Colors.white,
                  colorLabel: Colors.white,
                  colorText: Colors.white,
                  isPassword: true,
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.red, Colors.redAccent],
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
                      'Entrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
}
