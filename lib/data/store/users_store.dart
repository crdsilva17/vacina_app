import 'package:flutter/cupertino.dart';
import 'package:vacina_app/data/dto/register_request.dart';
import 'package:vacina_app/data/dto/user_request.dart';
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> update(UserRequest request) async {
    isLoading.value = true;
    try {
      state.value = await repository.update(request);
    } catch (ex) {
      error.value = ex.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser(RegisterRequest request) async {
    isLoading.value = true;
    try {
      state.value = await repository.register(request);
      error.value = '';
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
