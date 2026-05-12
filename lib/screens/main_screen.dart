import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/user_model.dart';
import 'package:vacina_app/data/repositories/users_repository.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/screens/check_screen.dart';
import 'package:vacina_app/screens/store/local_store.dart';
import 'package:vacina_app/screens/store/users_store.dart';
import 'package:vacina_app/util/custom_navigate.dart';
import 'package:vacina_app/widget/app_bar_section.dart';
import 'package:vacina_app/widget/hero_adm_section.dart';

import '../widget/hero_section.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UsersStore store = UsersStore(
    repository: UsersRepository(client: HttpClient()),
  );
  final LocalStore localStore = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );
  UserModel user = UserModel.empty();
  LocalModel local = LocalModel.empty();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // foto do usuário
                ),
              ),
              accountName: Text(user.name),
              accountEmail: Text(user.email),
              decoration: BoxDecoration(color: Colors.blue),
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                var shared = await SharedPreferences.getInstance();
                shared.remove('token');
                shared.remove('valid');
                Navigator.pop(context);
                push(context, CheckScreen(), replace: true);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.blue[200],
        child: CustomScrollView(
          slivers: [
            AppBarSection(onAvatarTap: openDrawer, user: user, local: local),
            _body(),
          ],
        ),
      ),
    );
  }

  SliverList _body() {
    if (user.role == 'ADMIN') {
      return SliverList(
        delegate: SliverChildListDelegate([
          const HeroAdmSection(),
          const Text('Conteúdo para administradores'),
        ]),
      );
    } else {
      return SliverList(
        delegate: SliverChildListDelegate([
          const HeroSection(),
          Center(child: const Text('Conteúdo para usuários comuns')),
        ]),
      );
    }
  }

  Future<void> _loadUser() async {
    await store.getUser();
    setState(() {
      user = store.state.value;
      _loadLocal();
    });
  }

  Future<void> _loadLocal() async {
    await localStore.getLocalById(user.localId);
    setState(() {
      local = localStore.state.value[0];
    });
  }
}
