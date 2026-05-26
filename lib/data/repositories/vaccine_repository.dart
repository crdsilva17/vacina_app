import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vacina_app/data/dto/vaccine_request.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

abstract class IVaccineRepository {
  Future<List<VaccineModel>> getVaccines();
  Future<void> postVaccine(VaccineRequest vaccine);
  Future<void> deleteVaccine(String id);
  Future<void> putVaccine(String id, VaccineRequest vaccine);
}

class VaccineRepository implements IVaccineRepository {
  final IHttpClient client;
  final storage = FlutterSecureStorage();
  final Map<String, String> url = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.vacinas,
  };

  VaccineRepository({required this.client});

  @override
  Future<void> deleteVaccine(String id) async {
    final String? token = await storage.read(key: 'token');
    url['endpoint'] = ApiEndpoints.vacinaById(id);
    await client.delete(token: token.toString(), uri: url);
  }

  @override
  Future<List<VaccineModel>> getVaccines() async {
    String? token = await storage.read(key: 'token');
    final response = await client.getAuth(uri: url, token: token.toString());
    List<VaccineModel> vaccines = [];

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      body.map((vaccine) {
        final VaccineModel vaccineModel = VaccineModel.fromJson(vaccine);
        vaccines.add(vaccineModel);
      }).toList();
    }
    return vaccines;
  }

  @override
  Future<void> postVaccine(VaccineRequest vaccine) async {
    String? token = await storage.read(key: 'token');
    await client.postAuth(
      token: token.toString(),
      uri: url,
      body: vaccine.toMap(),
    );
  }

  @override
  Future<void> putVaccine(String id, VaccineRequest vaccine) async {
    String? token = await storage.read(key: 'token');
    url['endpoint'] = ApiEndpoints.vacinaById(id);
    await client.put(token: token.toString(), uri: url, body: vaccine.toMap());
  }
}
