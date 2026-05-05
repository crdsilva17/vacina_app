import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/token_repository.dart';
import 'package:vacina_app/screens/check_screen.dart';
import 'package:vacina_app/util/custom_navigate.dart';
import 'package:vacina_app/widget/app_bar_section.dart';

import '../widget/hero_section.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var repository = TokenRepository(client: HttpClient());

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // foto do usuário
                ),
              ),
              accountName: Text('Cristiano'),
              accountEmail: Text('cristiano@email.com'),
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
            AppBarSection(onAvatarTap: openDrawer),
            const SliverToBoxAdapter(child: HeroSection()),
          ],
        ),
      ),
    );
  }
}
