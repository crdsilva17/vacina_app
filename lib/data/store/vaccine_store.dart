import 'package:flutter/material.dart';
import 'package:vacina_app/data/dto/vaccine_request.dart';
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

  Future<void> getVaccine(String id) async {
    isLoading.value = true;
    try {
      stateList.value = await repository.getVaccineById(id);
    } catch (e) {
      error.value = 'Error ao buscar vacinas: $e';
    }

    isLoading.value = false;
  }

  Future<void> post(VaccineRequest vaccine) async {
    isLoading.value = true;
    try {
      await repository.postVaccine(vaccine);
    } catch (e) {
      error.value = 'Error ao criar vacina: $e';
    }
    isLoading.value = false;
  }

  Future<void> put(String id, VaccineRequest vaccine) async {
    isLoading.value = true;
    try {
      await repository.putVaccine(id, vaccine);
    } catch (e) {
      error.value = 'Error ao atualizar vacina: $e';
    }
    isLoading.value = false;
  }

  Future<void> delete(String id) async {
    isLoading.value = true;
    try {
      await repository.deleteVaccine(id);
    } catch (e) {
      error.value = 'Error ao excluir vacina: $e';
    }
    isLoading.value = false;
  }
}
