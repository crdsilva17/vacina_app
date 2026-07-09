import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vacina_app/util/app_logger.dart';

abstract class IHttpClient {
  Future get({required Map<String, String> uri});

  Future getAuth({required Map<String, String> uri, required String token});

  Future postAuth({
    required String token,
    required Map<String, String> uri,
    required Map<String, dynamic> body,
  });

  Future post({
    required Map<String, String> uri,
    required Map<String, dynamic> body,
  });

  Future put({
    required String token,
    required Map<String, String> uri,
    required Map<String, dynamic> body,
  });

  Future patch({required Map<String, String> uri, required String token});

  Future delete({required String token, required Map<String, String> uri});
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<dynamic> get({required Map<String, String> uri}) async {
    var url = Uri.parse("${uri['base']}${uri['endpoint']}");
    try {
      return await client.get(url);
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição GET para: $url',
        name: 'http_client',
        error: e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<dynamic> post({
    required Map<String, String> uri,
    required Map<String, dynamic> body,
  }) async {
    var url = Uri.parse("${uri['base']}${uri['endpoint']}");
    try {
      return await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição POST para: $url',
        name: 'http_client',
        error: e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição GET Auth para: $url',
        name: 'http_client',
        error: e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<dynamic> put({
    required String token,
    required Map<String, String> uri,
    required Map<String, dynamic> body,
  }) async {
    var url = Uri.parse("${uri['base']}${uri['endpoint']}");
    try {
      return await client.put(
        url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição PUT para: $url',
        name: 'http_client',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> patch({
    required Map<String, String> uri,
    required String token,
  }) async {
    try {
      var url = Uri.parse("${uri['base']}${uri['endpoint']}");
      await client.patch(
        url,
        headers: {HttpHeaders.authorizationHeader: token},
      );
    } catch (ex) {
      Exception(ex);
    }
  }

  @override
  Future<void> delete({
    required String token,
    required Map<String, String> uri,
  }) async {
    var url = Uri.parse("${uri['base']}${uri['endpoint']}");
    try {
      await client.delete(
        url,
        headers: {HttpHeaders.authorizationHeader: token},
      );
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição DELETE para: $url',
        name: 'http_client',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future postAuth({
    required String token,
    required Map<String, String> uri,
    required Map<String, dynamic> body,
  }) async {
    var url = Uri.parse("${uri['base']}${uri['endpoint']}");
    try {
      await client.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição POST Auth para: $url',
        name: 'http_client',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
