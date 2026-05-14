import 'package:flutter/cupertino.dart';
import 'package:vacina_app/data/models/user_model.dart';
import 'package:vacina_app/data/repositories/users_repository.dart';

class UsersStore {
  final UsersRepository repository;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<UserModel> state = ValueNotifier<UserModel>(
    UserModel.empty(),
  );
  final ValueNotifier<String> error = ValueNotifier<String>('');

  UsersStore({required this.repository});

  Future<void> getUser() async {
    isLoading.value = true;
    try {
      final result = await repository.getUser();
      state.value = result;
    } catch (e) {
      error.value = e.toString();
    }
  }
}
