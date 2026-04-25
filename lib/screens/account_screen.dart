import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/screens/store/local_store.dart';
import 'package:vacina_app/widget/custom_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final LocalStore store = LocalStore(
    repository: LocalRepository(client: HttpClient()),
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

  _body() {
    _getlocalId();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: spacing),
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
              SizedBox(
                child: CustomTextField(
                  label: 'CPF',
                  icon: Icons.badge_outlined,
                  controller: cpfEditController,
                  colorBorder: Colors.black,
                  colorIcon: Colors.black,
                  colorLabel: Colors.black,
                  colorText: Colors.black,
                  colorBorderSide: Colors.black,
                ),
              ),
              SizedBox(height: spacing),
              SizedBox(
                child: CustomTextField(
                  label: 'Data de Nascimento',
                  icon: Icons.badge_outlined,
                  controller: dataNscEditController,
                  colorBorder: Colors.black,
                  colorIcon: Colors.black,
                  colorLabel: Colors.black,
                  colorText: Colors.black,
                  colorBorderSide: Colors.black,
                ),
              ),
              SizedBox(height: spacing),
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
              SizedBox(
                child: CustomTextField(
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
}
