import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/address_model.dart';
import 'package:vacina_app/data/repositories/address_repository.dart';
import 'package:vacina_app/util/app_logger.dart';

class AddressStore {
  final IAddressRepository repository;

  // variavel reativa para state
  final ValueNotifier<AddressModel> state = ValueNotifier<AddressModel>(
    AddressModel.empty(),
  );

  AddressStore({required this.repository});

  Future<void> fetchAddressByCep(String cep) async {
    try {
      final address = await repository.getAddressByCep(cep);
      state.value = address;
    } catch (e, stackTrace) {
      AppLogger.log(
        'Erro na requisição GET cep',
        name: 'address_store',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
