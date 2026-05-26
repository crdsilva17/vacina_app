import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';

abstract class ITokenRepository {
  Future<Map<String, dynamic>> getToken(Map<String, String> map);
  Future<Map<String, dynamic>> findToken();
  Future<void> deleteToken();
}

class TokenRepository implements ITokenRepository {
  final IHttpClient client;
  final storage = FlutterSecureStorage();
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
      await storage.write(key: 'token', value: 'Bearer ${body['token']}');
      await storage.write(
        key: 'validDate',
        value: '${DateTime.now().add(const Duration(hours: 24))}',
      );
      return body;
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>> findToken() async {
    String? token = await storage.read(key: 'token');
    String? valid = await storage.read(key: 'validDate');
    return {'token': token, 'valid': valid};
  }

  @override
  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'validDate');
  }
}
