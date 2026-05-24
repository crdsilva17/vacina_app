import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
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
  final Map<String, String> url = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.vacinas,
  };

  VaccineRepository({required this.client});

  @override
  Future<void> deleteVaccine(String id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
    url['endpoint'] = ApiEndpoints.vacinaById(id);
    await client.delete(token: token.toString(), uri: url);
  }

  @override
  Future<List<VaccineModel>> getVaccines() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
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
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
    final response = await client.postAuth(
      token: token.toString(),
      uri: url,
      body: vaccine.toMap(),
    );
  }

  @override
  Future<void> putVaccine(String id, VaccineRequest vaccine) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
    url['endpoints'] = ApiEndpoints.vacinaById(id);
    await client.put(token: token.toString(), uri: url, body: vaccine.toMap());
  }
}
