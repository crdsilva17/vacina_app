import 'dart:convert';

import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/address_model.dart';

abstract class IAddressRepository {
  Future<AddressModel> getAddressByCep(String cep);
}

class AddressRepository implements IAddressRepository {
  final IHttpClient client;
  final Map<String, String> url = {
    'base': ApiEndpoints.baseCep,
    'endpoint': ApiEndpoints.getCep(''),
  };

  AddressRepository({required this.client});

  @override
  Future<AddressModel> getAddressByCep(String cep) async {
    url['endpoint'] = ApiEndpoints.getCep(cep);
    final response = await client.get(uri: url);

    if (response.statusCode == 200) {
      return AddressModel.fromJson(jsonDecode(response.body));
    }
    return AddressModel.empty();
  }
}