import 'package:flutter/cupertino.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';

class LocalStore {
  final ILocalRepository repository;

  // variavel reativa para loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // variavel reativa para state
  final ValueNotifier<List<LocalModel>> state = ValueNotifier<List<LocalModel>>(
    [],
  );

  // variavel reativa para error
  final ValueNotifier<String> error = ValueNotifier<String>('');

  LocalStore({required this.repository});

  Future getLocal() async {
    isLoading.value = true;

    try {
      final result = await repository.getLocal();
      state.value = result;
    } catch (e) {
      error.value = 'Ocorreu um erro ${e.toString()}';
    }

    isLoading.value = false;
  }

  Future getLocalById(String id) async {
    isLoading.value = true;

    try {
      final result = await repository.getLocalById(id);
      state.value = [result];
    } catch (e) {
      error.value = 'Ocorreu um erro ${e.toString()}';
    }

    isLoading.value = false;
  }

  void updateLocal(LocalModel updatedLocal) async{
    await repository.updateLocal(updatedLocal);
    await getLocal();
  }
}
