import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vacina_app/data/dto/campanha_request.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/campanha_model.dart';

abstract class ICampanhaRepository {
  Future<void> criar(CampanhaRequest request);
  Future<List<CampanhaModel>> buscarTodos();
  Future<List<CampanhaModel>> buscarPorLocalId(String localId);
  Future<void> atualizar(String id, CampanhaRequest request);
  Future<void> deletar(String id);
}

class CampanhaRepository implements ICampanhaRepository {
  final IHttpClient client;
  final storage = FlutterSecureStorage();
  final Map<String, String> url = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.campanha,
  };

  CampanhaRepository({required this.client});

  @override
  Future<void> atualizar(String id, CampanhaRequest request) async {
    String? token = await storage.read(key: 'token');
    url['endpoint'] = ApiEndpoints.campanhaById(id);
    await client.put(token: token.toString(), uri: url, body: request.toMap());
  }

  @override
  Future<List<CampanhaModel>> buscarPorLocalId(String localId) async {
    String? token = await storage.read(key: 'token');
    url['endpoint'] = ApiEndpoints.campanhaByLocalId(localId);
    final response = await client.getAuth(uri: url, token: token.toString());
    List<CampanhaModel> campanhaList = [];

    if (response.statusCode == 200) {
      final body = jsonDecode(response);

      body.map((campanha) {
        CampanhaModel campanhaModel = CampanhaModel.fromJson(campanha);
        campanhaList.add(campanhaModel);
      }).toList();
    }

    return campanhaList;
  }

  @override
  Future<List<CampanhaModel>> buscarTodos() async {
    final String? token = await storage.read(key: 'token');
    url['endpoint'] = ApiEndpoints.campanha;
    final response = await client.getAuth(uri: url, token: token.toString());
    List<CampanhaModel> campanhaList = [];

    if (response.statusCode == 200) {
      final body = jsonDecode(response);
      body.map((campanha) {
        CampanhaModel campanhaModel = CampanhaModel.fromJson(campanha);
        campanhaList.add(campanhaModel);
      });
    }

    return campanhaList;
  }

  @override
  Future<void> criar(CampanhaRequest request) async {
    final String? token = await storage.read(key: 'token');
    final body = request.toMap();
    await client.postAuth(token: token.toString(), uri: url, body: body);
  }

  @override
  Future<void> deletar(String id) async {
    final String? token = await storage.read(key: 'token');
    url['endpoint'] = ApiEndpoints.campanhaById(id);
    await client.delete(token: token.toString(), uri: url);
  }
}
