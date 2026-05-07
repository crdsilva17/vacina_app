import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/user_model.dart';

import '../http/api_endpoints.dart';

abstract class IUsersRepository {
  Future<UserModel> getUser();
}

class UsersRepository implements IUsersRepository {
  final IHttpClient client;
  final Map<String, String> url = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.user,
  };

  UsersRepository({required this.client});

  @override
  Future<UserModel> getUser() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
    final response = await client.getAuth(uri: url, token: token.toString());
    UserModel user = UserModel.empty();
    try{
    if (response.statusCode == 200) {
      user = UserModel.fromJson(jsonDecode(response.body));
    }
    } catch (e) {
      print(e);
    }
    return user;
  }
}
