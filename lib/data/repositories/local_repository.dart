import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vacina_app/data/dto/local_request.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/local_model.dart';

abstract class ILocalRepository {
  Future<List<LocalModel>> getLocal();
  Future<LocalModel> getLocalById(String id);

  Future<void> updateLocal(LocalModel updatedLocal);
}

class LocalRepository implements ILocalRepository {
  final IHttpClient client;
  final Map<String, String> url = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.locais,
  };

  LocalRepository({required this.client});

  @override
  Future<LocalModel> getLocalById(String id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
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
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
    final LocalRequest localRequest = LocalRequest.fromLocalModel(updatedLocal);
    url['base'] = ApiEndpoints.baseUrl;
    url['endpoint'] = ApiEndpoints.localPut(updatedLocal.id);
    return client.put(
      token: token.toString(),
      uri: url,
      body: localRequest.toMap(),
    );
  }
}
