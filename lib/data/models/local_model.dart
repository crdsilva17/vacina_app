class LocalModel {
  final String id;
  final String name;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;
  final String horarioFuncionamento;

  LocalModel({
    required this.id,
    required this.name,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.horarioFuncionamento,
  });

  LocalModel.empty()
    : id = '',
      name = '',
      rua = '',
      numero = '',
      bairro = '',
      cidade = '',
      estado = '',
      cep = '',
      horarioFuncionamento = '';
  
  LocalModel copyWith({
    String? id,
    String? name,
    String? rua,
    String? numero,
    String? bairro,
    String? cidade,
    String? estado,
    String? cep,
    String? horarioFuncionamento,
  }) {
    return LocalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      horarioFuncionamento: horarioFuncionamento ?? this.horarioFuncionamento,
    );
  }

  factory LocalModel.fromMap(Map<String, dynamic> map) {
    return LocalModel(
      id: map['id'],
      name: map['name'],
      rua: map['rua'],
      numero: map['numero'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      estado: map['estado'],
      cep: map['cep'],
      horarioFuncionamento: map['horarioFuncionamento'],
    );
  }
}
