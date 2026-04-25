import 'dart:convert';

import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/local_model.dart';

abstract class ILocalRepository {
  Future<List<LocalModel>> getLocal();
}

class LocalRepository implements ILocalRepository {
  final IHttpClient client;

  LocalRepository({required this.client});

  @override
  Future<List<LocalModel>> getLocal() async {
    final response = await client.get(
      url: 'http://localhost:8080/api/v1/locais',
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
