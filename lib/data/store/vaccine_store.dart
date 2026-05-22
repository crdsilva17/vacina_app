import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/data/repositories/vaccine_repository.dart';

class VaccineStore {
  final IVaccineRepository repository;
  final ValueNotifier<List<VaccineModel>> stateList = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> error = ValueNotifier('');

  VaccineStore({required this.repository});

  Future<void> getList() async {
    isLoading.value = true;
    try {
      stateList.value = await repository.getVaccines();
    } catch (e) {
      error.value = 'Error ao buscar lista de vacinas:  $e';
    }

    isLoading.value = false;
  }
}
