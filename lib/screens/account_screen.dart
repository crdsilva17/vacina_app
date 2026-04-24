import 'package:flutter/material.dart';
import 'package:vacina_app/widget/custom_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final TextEditingController nomeEditController = TextEditingController();
  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController cpfEditController = TextEditingController();
  final TextEditingController postoEditController = TextEditingController();
  final TextEditingController senhaEditController = TextEditingController();
  final double spacing = 30;

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

  _body() {
    return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: spacing*3,),
                SizedBox(
                  child: CustomTextField(label: 'Nome',
                      icon: Icons.person_outlined,
                      controller: nomeEditController,
                      colorBorder: Colors.black,
                      colorIcon: Colors.black,
                      colorLabel: Colors.black,
                      colorText: Colors.black,
                      colorBorderSide: Colors.black,
                  ),
                ),
                SizedBox(height: spacing,),
                SizedBox(
                  child: CustomTextField(label: 'CPF',
                    icon: Icons.badge_outlined,
                    controller: cpfEditController,
                    colorBorder: Colors.black,
                    colorIcon: Colors.black,
                    colorLabel: Colors.black,
                    colorText: Colors.black,
                    colorBorderSide: Colors.black,
                  ),
                ),
                SizedBox(height: spacing,),
                SizedBox(
                  child: CustomTextField(label: 'Posto de Saúde',
                    icon: Icons.medical_services_outlined,
                    controller: postoEditController,
                    colorBorder: Colors.black,
                    colorIcon: Colors.black,
                    colorLabel: Colors.black,
                    colorText: Colors.black,
                    colorBorderSide: Colors.black,
                  ),
                ),
                SizedBox(height: spacing,),
                SizedBox(
                  child: CustomTextField(label: 'E-mail',
                    icon: Icons.email_outlined,
                    controller: emailEditController,
                    colorBorder: Colors.black,
                    colorIcon: Colors.black,
                    colorLabel: Colors.black,
                    colorText: Colors.black,
                    colorBorderSide: Colors.black,
                  ),
                ),

                SizedBox(height: spacing,),
                SizedBox(
                  child: CustomTextField(label: 'Senha',
                    icon: Icons.password_outlined,
                    controller: senhaEditController,
                    colorBorder: Colors.black,
                    colorIcon: Colors.black,
                    colorLabel: Colors.black,
                    colorText: Colors.black,
                    colorBorderSide: Colors.black,
                  ),
                ),
                SizedBox(height: spacing*2,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blueAccent,
                        Colors.blue,
                      ],
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
}
