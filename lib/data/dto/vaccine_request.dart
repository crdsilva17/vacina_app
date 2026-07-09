import 'package:intl/intl.dart';

class VaccineRequest {
  final String nome;
  final String descricao;
  final String fabricante;
  final String dataFabricacao;
  final String dataValidade;
  final String lote;
  final String doses;

  VaccineRequest({
    required this.nome,
    required this.descricao,
    required this.fabricante,
    required this.dataFabricacao,
    required this.dataValidade,
    required this.lote,
    required this.doses,
  });

  factory VaccineRequest.fromMapEntry(MapEntry entry) {
    return VaccineRequest(
      nome: entry.value['name']!.text,
      descricao: entry.value['description']!.text,
      fabricante: entry.value['manufacturer']!.text,
      dataFabricacao: entry.value['manufactureDate']!.text,
      dataValidade: entry.value['expiryDate']!.text,
      lote: entry.value['lot']!.text,
      doses: entry.value['doses']!.text,
    );
  }

  Map<String, dynamic> toMap() {
    DateTime dateTime1 = DateFormat('dd/MM/yyyy').parse(dataFabricacao);
    DateTime dateTime2 = DateFormat('dd/MM/yyyy').parse(dataValidade);

    String formattedDate1 = DateFormat('yyyy-MM-dd').format(dateTime1);
    String formattedDate2 = DateFormat('yyyy-MM-dd').format(dateTime2);

    return {
      'nome': nome,
      'descricao': descricao,
      'fabricante': fabricante,
      'dataFabricacao': formattedDate1,
      'dataValidade': formattedDate2,
      'lote': lote,
      'doses':
          doses, // [DUAS_DOSES, QUATRO_DOSES, DOSE_UNICA, VARIAS_DOSES, TRES_DOSES]
    };
  }
}
