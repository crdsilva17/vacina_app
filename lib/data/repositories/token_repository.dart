import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/user_token.dart';

abstract class ITokenRepository {
  Future<String> getToken(Map<String, String> map);
}

class TokenRepository implements ITokenRepository {
  final IHttpClient client;
  final String baseUrl = kIsWeb
      ? 'http://localhost:8080/api/v1/auth/login'
      : 'http://10.0.2.2:8080/api/v1/auth/login';

  TokenRepository({required this.client});

  @override
  Future<String> getToken(Map<String, String> map) async {
    final response = await client.post(url: baseUrl, dados: map);
    final body = jsonDecode(response.body);
    body.map((item) {
      final UserToken value = UserToken.fromMap(item);
      return value.token;
    });

    return "";
  }
}
