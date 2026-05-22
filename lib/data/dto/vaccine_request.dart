class VaccineRequest {
  final String nome;
  final String descricao;
  final String local;
  final String fabricante;
  final String dataFabricacao;
  final String dataValidade;
  final String lote;
  final String doses;
  final String idadeMaxima;
  final String idadeMinima;
  final String quantidadeDisponivel;

  VaccineRequest({
    required this.nome,
    required this.descricao,
    required this.local,
    required this.fabricante,
    required this.dataFabricacao,
    required this.dataValidade,
    required this.lote,
    required this.doses,
    required this.idadeMaxima,
    required this.idadeMinima,
    required this.quantidadeDisponivel,
  });

  Map<String, String> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'local': local,
      'fabricante': fabricante,
      'dataFabricacao': dataFabricacao,
      'dataValidade': dataValidade,
      'lote': lote,
      'doses': doses,
      'idadeMaxima': idadeMaxima,
      'idadeMinima': idadeMinima,
      'quantidadeDisponivel': quantidadeDisponivel,
    };
  }
}
