import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required Map<String, String> uri});

  Future getAuth({
    required Map<String, String> uri,
    required String token,
  });

  Future post({
    required Map<String, String> uri,
    required Map<String, String> body,
  });
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<dynamic> get({required Map<String, String> uri}) async {
    var url = Uri.parse("${uri['base']}${uri['endpoint']}");
    try {
      return await client.get(url);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<dynamic> post({
    required Map<String, String> uri,
    required Map<String, String> body,
  }) async {
    try {
      var url = Uri.parse("${uri['base']}${uri['endpoint']}");
      return await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );
    } catch (e) {
      print(e);
    }

    return null;
  }

  @override
  Future<dynamic> getAuth({
    required Map<String, String> uri,
    required String token,
  }) async {
    var url = Uri.parse("${uri['base']}${uri['endpoint']}");
    try {
      return await client.get(
        url, 
        headers: {HttpHeaders.authorizationHeader: token},
        );
    } catch (e) {
      print(e);
    }
    return null;
  }
}
