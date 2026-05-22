class VaccineModel {
  final String id;
  final String name;
  final String manufacturer;
  final String manufactureDate;
  final String expiryDate;
  final String lot;
  final int minRecommendedAge;
  final int maxRecommendedAge;
  final String posto;
  final String doses;
  final String description;
  final int stockQuantity;

  VaccineModel({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.manufactureDate,
    required this.expiryDate,
    required this.lot,
    required this.minRecommendedAge,
    required this.maxRecommendedAge,
    required this.posto,
    required this.doses,
    required this.description,
    required this.stockQuantity,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      id: json['id'],
      name: json['name'] ?? 'Não informado.',
      manufacturer: json['manufacturer'] ?? 'Desconhecido.',
      manufactureDate: json['manufactureDate'] ?? '1990-01-01',
      expiryDate: json['expiryDate'] ?? '1991-01-01',
      lot: json['lot'] ?? '0',
      minRecommendedAge: json['minRecommendedAge'] ?? 0,
      maxRecommendedAge: json['maxRecommendedAge'] ?? 1,
      posto: json['posto'] ?? 'Não informado.',
      doses: json['doses'] ?? 0,
      description: json['description'] ?? 'Sem descrição.',
      stockQuantity: json['stockQuantity'] ?? 0,
    );
  }
}
