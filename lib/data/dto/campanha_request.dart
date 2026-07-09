import 'package:intl/intl.dart';

class CampanhaRequest {
  final String nome;
  final String vacinaId;
  final List<String> localIds;
  final String dataInicio;
  final String dataFim;
  final String ageMin;
  final String ageMax;

  CampanhaRequest({
    required this.nome,
    required this.vacinaId,
    required this.localIds,
    required this.dataInicio,
    required this.dataFim,
    required this.ageMin,
    required this.ageMax,
  });

  factory CampanhaRequest.fromMap(Map map) {
    return CampanhaRequest(
      nome: map['nome'],
      vacinaId: map['vacinaId'],
      localIds: map['localIds'],
      dataInicio: map['dataInicio'],
      dataFim: map['dataFim'],
      ageMin: map['ageMin'],
      ageMax: map['ageMax'],
    );
  }

  Map<String, dynamic> toMap() {
    DateTime dateTime1 = DateFormat('dd/MM/yyyy').parse(dataInicio);
    DateTime dateTime2 = DateFormat('dd/MM/yyyy').parse(dataFim);

    String formattedDate1 = DateFormat('yyyy-MM-dd').format(dateTime1);
    String formattedDate2 = DateFormat('yyyy-MM-dd').format(dateTime2);

    return {
      'nome': nome,
      'vacinaId': vacinaId,
      'localIds': localIds,
      'datainicio': formattedDate1,
      'dataFim': formattedDate2,
      'ageMin': ageMin,
      'ageMax': ageMax,
    };
  }
}
