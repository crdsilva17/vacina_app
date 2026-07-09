import 'package:intl/intl.dart';

class VaccineModel {
  final String id;
  final String name;
  final String manufacturer;
  final String manufactureDate;
  final String expiryDate;
  final String lot;
  final String doses;
  final String description;

  VaccineModel({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.manufactureDate,
    required this.expiryDate,
    required this.lot,
    required this.doses,
    required this.description,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    DateTime dateTime1 = DateFormat(
      'yyyy-MM-dd',
    ).parse(json['dataFabricacao'] ?? '1990-01-01');
    DateTime dateTime2 = DateFormat(
      'yyyy-MM-dd',
    ).parse(json['dataValidade'] ?? '1991-01-01');

    String formattedDate1 = DateFormat('dd/MM/yyyy').format(dateTime1);
    String formattedDate2 = DateFormat('dd/MM/yyyy').format(dateTime2);

    return VaccineModel(
      id: json['id'],
      name: json['nome'] ?? 'Não informado.',
      manufacturer: json['fabricante'] ?? 'Desconhecido.',
      manufactureDate: formattedDate1,
      expiryDate: formattedDate2,
      lot: json['lote'] ?? '0',
      doses: json['doses'] ?? 0,
      description: json['descricao'] ?? 'Sem descrição.',
    );
  }
}
