import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/campanha_model.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/user_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/data/repositories/campanha_repository.dart';
import 'package:vacina_app/data/repositories/users_repository.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/repositories/vaccine_repository.dart';
import 'package:vacina_app/data/store/campanha_store.dart';
import 'package:vacina_app/data/store/vaccine_store.dart';
import 'package:vacina_app/screens/change_pass_screen.dart';
import 'package:vacina_app/screens/check_screen.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:vacina_app/data/store/users_store.dart';
import 'package:vacina_app/util/app_logger.dart';
import 'package:vacina_app/util/change_name_page.dart';
import 'package:vacina_app/util/custom_navigate.dart';
import 'package:vacina_app/util/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vacina_app/util/notification_service.dart';
import 'package:vacina_app/widget/app_bar_section.dart';
import 'package:vacina_app/widget/hero_adm_section.dart';

import 'package:flutter/foundation.dart'; // Obrigatório para usar kIsWeb
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widget/hero_section.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final locationService = LocationService();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  int count = 0;
  final UsersStore store = UsersStore(
    repository: UsersRepository(client: HttpClient()),
  );
  final LocalStore localStore = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

  final CampanhaStore campanhaStore = CampanhaStore(
    repository: CampanhaRepository(client: HttpClient()),
  );

  final NotificationService notificationService = NotificationService();

  final VaccineStore vaccineStore = VaccineStore(
    repository: VaccineRepository(client: HttpClient()),
  );

  String city = 'Obtendo localização...';
  UserModel user = UserModel.empty();
  LocalModel local = LocalModel.empty();
  List<VaccineModel> vaccines = [];
  List<CampanhaModel> campanhas = [];

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    loadLocation();
    _getCount();
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
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              accountName: Text(user.name),
              accountEmail: Text(user.email),
              decoration: BoxDecoration(color: Colors.blue),
            ),

            const ListTile(
              title: Text(
                'Dados Pessoais',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Nome'),
              subtitle: Text(user.name),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Data de Nascimento'),
              subtitle: Text(
                user.birth.isNotEmpty
                    ? DateFormat(
                        'dd/MM/yyyy',
                      ).format(DateTime.parse(user.birth))
                    : '',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital_outlined),
              title: const Text('UBS'),
              subtitle: Text(user.localId),
            ),
            ListTile(
              title: const Text('Editar perfil'),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNamePage(
                      currentName: user.name,
                      currentDate: DateFormat(
                        'dd/MM/yyyy',
                      ).format(DateTime.parse(user.birth)),
                      currentUBS: user.localId,
                      email: user.email,
                    ),
                  ),
                );
              },
            ),

            const Divider(),

            const ListTile(
              title: Text(
                'Segurança',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Alterar Senha'),
              onTap: () {
                push(context, ChangePassScreen(email: user.email));
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                store.repository.logout();
                _close();
                _open(CheckScreen(), true);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.blue[200],
        child: CustomScrollView(
          slivers: [
            AppBarSection(
              onAvatarTap: openDrawer,
              user: user,
              local: local,
              place: city,
              count: count,
              storage: storage,
              setState: _getCount,
            ),
            _body(context),
          ],
        ),
      ),
    );
  }

  SliverList _body(BuildContext context) {
    if (user.role == 'ADMIN') {
      return SliverList(
        delegate: SliverChildListDelegate([
          Center(child: HeroAdmSection(context: context)),
        ]),
      );
    } else {
      return SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: HeroSection(
              user: user,
              local: local,
              vaccines: vaccines,
              campanhas: campanhas,
            ),
          ),
        ]),
      );
    }
  }

  Future<void> _loadUser() async {
    await store.getUser();
    setState(() {
      user = store.state.value;
    });
    await _loadLocal();
  }

  Future<void> _loadLocal() async {
    await localStore.getLocalByNome(user.localId);
    setState(() {
      local = localStore.state.value[0];
    });
    await _loadVaccines();
  }

  int userAge(String dataNascimentoStr, {String formato = 'dd/MM/yyyy'}) {
    // 1. Converte a String para DateTime
    DateFormat formatoData = DateFormat(formato);
    DateTime dataNascimento = formatoData.parse(dataNascimentoStr);

    // 2. Pega a data atual
    DateTime hoje = DateTime.now();

    // 3. Calcula a diferença de anos
    int idade = hoje.year - dataNascimento.year;

    // 4. Ajusta caso o aniversário ainda não tenha ocorrido este ano
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }

    return idade;
  }

  /*
    Verifica se existe campanha cadastrada para a UBS
    se existir, carrega as vacinas ofertadas.
  */
  Future<void> _loadVaccines() async {
    final int idade = userAge(user.birth, formato: 'yyyy-MM-dd');
    await campanhaStore.getByLocalId(local.id);
    List<VaccineModel> vaccineList = [];
    for (CampanhaModel c in campanhaStore.stateList.value) {
      if (int.parse(c.ageMin) <= idade && int.parse(c.ageMax) >= idade) {
        await vaccineStore.getVaccine(c.vacinaId.toString());
        if (vaccineStore.stateList.value.isNotEmpty) {
          vaccineList.add(vaccineStore.stateList.value.first);
          campanhas.add(c);
        }
      }
    }

    setState(() {
      vaccines = vaccineList;
    });
  }

  /*
  Future<void> loadLocation() async {
    try {
      final position = await locationService.getCurrentLocation();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;

      if (!mounted) return;

      setState(() {
        city = place.locality ?? 'Cidade não encontrada!';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        city = 'Localização indisponível!';
      });
    }
  }
  */

  Future<void> loadLocation() async {
    try {
      final position = await locationService.getCurrentLocation();
      String? detectedCity;

      if (kIsWeb) {
        // Solução para Web: Geocodificação via API HTTP gratuita (Nominatim)
        final url = Uri.parse(ApiEndpoints.openStreetMap(position.longitude));

        // O Nominatim exige um User-Agent válido no cabeçalho
        final response = await http.get(
          url,
          headers: {'User-Agent': 'MeuAppFlutter'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final address = data['address'] ?? {};
          detectedCity =
              address['city'] ??
              address['town'] ??
              address['village'] ??
              address['suburb'];
        }
      } else {
        // Solução para Android APK (Usa o pacote geocoding nativo)
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        detectedCity = placemarks.first.locality;
      }

      if (!mounted) return;

      setState(() {
        city = detectedCity ?? 'Cidade não encontrada!';
      });
    } catch (e, stackTrace) {
      if (!mounted) return;
      setState(() {
        // Exibe o erro real no console para ajudar no seu debug
        AppLogger.log(
          'Erro ao carregar localização',
          name: 'main_screen',
          error: e,
          stackTrace: stackTrace,
        );
        city = 'Localização indisponível!';
      });
    }
  }

  void _open(Widget screen, bool repl) {
    push(context, screen, replace: repl);
  }

  void _getCount() async {
    final String? token = await storage.read(key: 'token');
    if (token == null) return;
    count = await notificationService.getCount(token);
    setState(() {});
  }

  void _close() {
    Navigator.pop(context);
  }
}
