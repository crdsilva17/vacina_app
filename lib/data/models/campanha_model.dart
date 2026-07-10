import 'package:intl/intl.dart';
import 'package:vacina_app/widget/vaccine_status_card.dart';

class CampanhaModel {
  final String id;
  final String nome;
  final String vacinaId;
  final List<String> localIds;
  final String dataInicio;
  final String dataFim;
  final String ageMin;
  final String ageMax;

  CampanhaModel({
    required this.id,
    required this.nome,
    required this.vacinaId,
    required this.localIds,
    required this.dataInicio,
    required this.dataFim,
    required this.ageMin,
    required this.ageMax,
  });

  factory CampanhaModel.fromJson(Map<String, dynamic> json) {
    DateTime dateTime1 = DateFormat(
      'yyyy-MM-dd',
    ).parse(json['dataInicio'] ?? '1990-01-01');
    DateTime dateTime2 = DateFormat(
      'yyyy-MM-dd',
    ).parse(json['dataFim'] ?? '1991-01-01');

    String formattedDate1 = DateFormat('dd/MM/yyyy').format(dateTime1);
    String formattedDate2 = DateFormat('dd/MM/yyyy').format(dateTime2);

    return CampanhaModel(
      id: json['id'],
      nome: json['nome'],
      vacinaId: json['vacinaId'],
      localIds: json['localIds'] != null
          ? List<String>.from(json['localIds'])
          : [],
      dataInicio: formattedDate1,
      dataFim: formattedDate2,
      ageMin: json['ageMin'] ?? '0',
      ageMax: json['ageMax'] ?? '0',
    );
  }

  static CampanhaModel empty() {
    return CampanhaModel(
      id: '',
      nome: '',
      vacinaId: '',
      localIds: [],
      dataInicio: '',
      dataFim: '',
      ageMin: '',
      ageMax: '',
    );
  }
}
