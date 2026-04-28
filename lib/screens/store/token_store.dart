

import 'package:flutter/cupertino.dart';
import 'package:vacina_app/data/models/user_token.dart';
import 'package:vacina_app/data/repositories/token_repository.dart';

class TokenStore {
  final ITokenRepository repository;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<UserToken> state = ValueNotifier(UserToken(token: ''));
  final ValueNotifier<String> error = ValueNotifier('');

  TokenStore({required this.repository});

  Future getToken(Map<String, String> map) async {
    isLoading.value = true;
    try {
      final result = await repository.getToken(map);
      state.value = UserToken(token: result.values.first);
    }catch(e) {
      error.value = 'Falha ao realizar login: $e';
      throw Exception(error.value);
    } finally {
      isLoading.value = false;
    }
  }
}