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
