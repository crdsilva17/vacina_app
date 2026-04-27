import 'dart:convert';

import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/local_model.dart';

import 'package:flutter/foundation.dart';

abstract class ILocalRepository {
  Future<List<LocalModel>> getLocal();
}

class LocalRepository implements ILocalRepository {
  final IHttpClient client;
  final String baseUrl = kIsWeb
      ? 'http://localhost:8080/api/v1/locais'
      : 'http://10.0.2.2:8080/api/v1/locais';
  LocalRepository({required this.client});

  @override
  Future<List<LocalModel>> getLocal() async {
    final response = await client.get(
      url: baseUrl,
    );

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
}
