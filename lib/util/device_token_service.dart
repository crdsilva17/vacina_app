import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';

class DeviceTokenService {
  Future<void> registerToken(String token, String jwt) async {
    HttpClient client = HttpClient();

    Map<String, String> uri = {
      'base': ApiEndpoints.baseUrl,
      'endpoint': ApiEndpoints.registerToken,
    };

    Map<String, dynamic> body = {'token': token};

    await client.postAuth(token: jwt, uri: uri, body: body);
  }
}
