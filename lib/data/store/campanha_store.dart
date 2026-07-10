import 'package:flutter/widgets.dart';
import 'package:vacina_app/data/dto/campanha_request.dart';
import 'package:vacina_app/data/models/campanha_model.dart';
import 'package:vacina_app/data/repositories/campanha_repository.dart';
import 'package:vacina_app/util/app_logger.dart';

class CampanhaStore {
  final ICampanhaRepository repository;
  final ValueNotifier<List<CampanhaModel>> stateList = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> error = ValueNotifier('');

  CampanhaStore({required this.repository});

  Future<void> getList() async {
    isLoading.value = true;
    try {
      stateList.value = await repository.buscarTodos();
    } catch (e, stackTrace) {
      error.value = 'Error ao buscar Campanhas';
      AppLogger.log(
        'Error ao buscar Campanhas',
        name: 'CampanhaStore',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getByLocalId(String localId) async {
    isLoading.value = true;
    try {
      stateList.value = await repository.buscarPorLocalId(localId);
    } catch (e) {
      error.value = 'Error ao buscar por UBS';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> criar(CampanhaRequest request) async {
    isLoading.value = true;
    try {
      await repository.criar(request);
    } catch (e, stackTrace) {
      error.value = 'Error ao criar nova Campanha';
      AppLogger.log(
        'Erro ao criar nova campanha.',
        error: e,
        stackTrace: stackTrace,
        name: 'CamapnhaStore',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atualizar(String id, CampanhaRequest request) async {
    isLoading.value = true;
    try {
      await repository.atualizar(id, request);
    } catch (e) {
      error.value = 'Error ao atualizar Campanha';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletar(String id) async {
    isLoading.value = true;
    try {
      await repository.deletar(id);
    } catch (e) {
      error.value = 'Error ao deletar Campanha';
    } finally {
      isLoading.value = false;
    }
  }
}
