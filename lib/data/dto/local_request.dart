import 'package:vacina_app/data/models/local_model.dart';

class LocalRequest {
  final String name;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;
  final String horarioFuncionamento;

  LocalRequest({
    required this.name,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.horarioFuncionamento,
  });

  factory LocalRequest.fromLocalModel(LocalModel local) {
    return LocalRequest(
      name: local.name,
      rua: local.rua,
      numero: local.numero,
      bairro: local.bairro,
      cidade: local.cidade,
      estado: local.estado,
      cep: local.cep,
      horarioFuncionamento: local.horarioFuncionamento,
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'horarioFuncionamento': horarioFuncionamento,
    };
  }

}
