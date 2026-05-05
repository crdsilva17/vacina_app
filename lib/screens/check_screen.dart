import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/token_repository.dart';
import 'package:vacina_app/screens/login_screen.dart';
import 'package:vacina_app/screens/main_screen.dart';
import 'package:vacina_app/util/custom_navigate.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  TokenRepository repository = TokenRepository(client: HttpClient());

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Widget? _body() {
    return Center(child: CircularProgressIndicator());
  }

  Future<void> _loadToken() async {
    var token = await repository.findToken();
    if (token['token'] != null &&
        token['valid'] != null &&
        DateTime.parse(token['valid']).isAfter(DateTime.now())) {
      push(context, MainScreen(), replace: true);
    } else {
      push(context, LoginScreen(), replace: true);
    }
  }
}
