import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vacina_app/data/dto/local_request.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/local_model.dart';

abstract class ILocalRepository {
  Future<List<LocalModel>> getLocal();
  Future<LocalModel> getLocalById(String id);

  Future<void> createLocal(LocalRequest localRequest);

  Future<void> updateLocal(LocalModel updatedLocal);

  Future<void> deleteLocal(String id);
}

class LocalRepository implements ILocalRepository {
  final IHttpClient client;
  final storage = FlutterSecureStorage();
  final Map<String, String> url = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.locais,
  };

  LocalRepository({required this.client});

  @override
  Future<LocalModel> getLocalById(String id) async {
    String? token = await storage.read(key: 'token');
    url['endpoint'] = ApiEndpoints.getLocalById(id);
    final response = await client.getAuth(uri: url, token: token.toString());

    if (response.statusCode == 200) {
      return LocalModel.fromMap(jsonDecode(response.body));
    }
    return LocalModel.empty();
  }

  @override
  Future<List<LocalModel>> getLocal() async {
    final response = await client.get(uri: url);

    if (response.statusCode == 200) {
      final List<LocalModel> localList = [];
      final body = jsonDecode(response.body);
      body.map((item) {
        final LocalModel local = LocalModel.fromMap(item);
        localList.add(local);
      }).toList();
      return localList;
    }
    return [];
  }

  @override
  Future<void> updateLocal(LocalModel updatedLocal) async {
    String? token = await storage.read(key: 'token');
    final LocalRequest localRequest = LocalRequest.fromLocalModel(updatedLocal);
    url['base'] = ApiEndpoints.baseUrl;
    url['endpoint'] = ApiEndpoints.localById(updatedLocal.id);
    return await client.put(
      token: token.toString(),
      uri: url,
      body: localRequest.toMap(),
    );
  }

  @override
  Future<void> deleteLocal(String id) async {
    String? token = await storage.read(key: 'token');
    url['base'] = ApiEndpoints.baseUrl;
    url['endpoint'] = ApiEndpoints.localById(id);
    return await client.delete(token: token.toString(), uri: url);
  }

  @override
  Future<void> createLocal(LocalRequest localRequest) async {
    String? token = await storage.read(key: 'token');
    url['base'] = ApiEndpoints.baseUrl;
    url['endpoint'] = ApiEndpoints.locais;

    return await client.postAuth(
      token: token.toString(),
      uri: url,
      body: localRequest.toMap(),
    );
  }
}
