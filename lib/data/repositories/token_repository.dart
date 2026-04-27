import 'package:flutter/foundation.dart';
import 'package:vacina_app/data/http/http_client.dart';

abstract class ITokenRepository {
  Future<String> getToken();
}

class TokenRepository implements ITokenRepository {
  final IHttpClient client;
  final String baseUrl = kIsWeb
      ? 'http://localhost:8080/api/v1/locais'
      : 'http://10.0.2.2:8080/api/v1/locais';

  TokenRepository({required this.client});

  @override
  Future<String> getToken() async {
    final response = await client.get(url: baseUrl);
    return '';
  }
}
