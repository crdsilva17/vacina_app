class VaccineModel {
  final int id;
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
      name: json['name'],
      manufacturer: json['manufacturer'],
      manufactureDate: json['manufactureDate'],
      expiryDate: json['expiryDate'],
      lot: json['lot'],
      minRecommendedAge: json['minRecommendedAge'],
      maxRecommendedAge: json['maxRecommendedAge'],
      posto: json['posto'],
      doses: json['doses'],
      description: json['description'],
      stockQuantity: json['stockQuantity'],
    );
  }
}
