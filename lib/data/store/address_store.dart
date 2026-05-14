import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/address_model.dart';
import 'package:vacina_app/data/repositories/address_repository.dart';

class AddressStore {
  final IAddressRepository repository;

  // variavel reativa para state
  final ValueNotifier<AddressModel> state = ValueNotifier<AddressModel>(AddressModel.empty());

  AddressStore({required this.repository});

  Future<void> fetchAddressByCep(String cep) async {
    try {
      final address = await repository.getAddressByCep(cep);
      state.value = address;
    } catch (e) {
      // Tratar erros, se necessário
      print('Erro ao buscar endereço: $e');
    }
  }
}