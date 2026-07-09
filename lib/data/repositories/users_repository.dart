import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vacina_app/data/dto/register_request.dart';
import 'package:vacina_app/data/dto/user_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/user_model.dart';
import 'package:vacina_app/util/app_logger.dart';

import '../http/api_endpoints.dart';

abstract class IUsersRepository {
  Future<UserModel> getUser();
  Future<UserModel> register(RegisterRequest request);
  Future<void> update(UserRequest request);
  Future<void> logout();
  Future<UserModel> changePassword(Map<String, String> body);
}

class UsersRepository implements IUsersRepository {
  final IHttpClient client;
  final storage = FlutterSecureStorage();
  final Map<String, String> url = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.user,
  };

  UsersRepository({required this.client});

  @override
  Future<UserModel> getUser() async {
    final String? token = await storage.read(key: 'token');
    final response = await client.getAuth(uri: url, token: token.toString());
    UserModel user = UserModel.empty();
    try {
      if (response.statusCode == 200) {
        user = UserModel.fromJson(jsonDecode(response.body));
      }
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição GET User para: $url',
        name: 'http_client',
        error: e,
        stackTrace: stackTrace,
      );
    }
    return user;
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    url['endpoint'] = ApiEndpoints.register;
    try {
      final response = await client.post(uri: url, body: request.toMap());
      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        UserModel userModel = UserModel.empty();
        userModel.email = body['email'];
        userModel.name = body['nome'];
        return userModel;
      } else if (response.statusCode == 409) {
        throw Exception(jsonDecode(response.body)["message"]);
      }
      throw Exception("Error ao registrar usuário.");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'validDate');
  }

  @override
  Future<UserModel> update(UserRequest request) async {
    final String? token = await storage.read(key: 'token');
    UserModel userModel = UserModel.empty();
    if (token == null) return userModel;
    final response = await client.put(
      uri: url,
      token: token,
      body: request.toMap(),
    );
    userModel = UserModel.fromJson(jsonDecode(response.body));
    return userModel;
  }

  @override
  Future<UserModel> changePassword(Map<String, String> body) async {
    final String? token = await storage.read(key: 'token');
    UserModel userModel = UserModel.empty();
    if (token == null) return userModel;
    url['endpoint'] = ApiEndpoints.change;

    final response = await client.put(token: token, uri: url, body: body);
    userModel = UserModel.fromJson(jsonDecode(response.body));
    return userModel;
  }
}
