import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';

abstract class ITokenRepository {
  Future<Map<String, dynamic>> getToken(Map<String, String> map);
  Future<Map<String, dynamic>> findToken();
  Future<void> deleteToken();
}

class TokenRepository implements ITokenRepository {
  final IHttpClient client;
  final Map<String, String> urlLogin = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.login,
  };

  TokenRepository({required this.client});

  @override
  Future<Map<String, dynamic>> getToken(Map<String, String> map) async {
    final response = await client.post(uri: urlLogin, body: map);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      SharedPreferences shared = await SharedPreferences.getInstance();
      shared.setString('token', 'Bearer ${body['token']}');
      shared.setString(
        'validDate',
        '${DateTime.now().add(const Duration(hours: 24))}',
      );
      return body;
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>> findToken() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var token = shared.get('token');
    var valid = shared.get('validDate');
    return {'token':token, 'valid': valid};
  }

  @override
  Future<void> deleteToken() async{
    var shared = await SharedPreferences.getInstance();
    shared.remove('token');
    shared.remove('valid');
  }
}
