import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required String url});

  Future post({required String url, required Map<String, String> dados});
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<dynamic> get({required String url}) async {
    return await client.get(Uri.parse(url));
  }

  @override
  Future<dynamic> post({
    required String url,
    required Map<String, String> dados,
  }) async {
    try {
      String email = dados.keys.first;
      String senha = dados.values.first;
      Map<String, String> data = {'email':email, 'senha':senha};
      return await client.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(data));
    }catch(e){
      throw Exception(e);
    }
  }
}
