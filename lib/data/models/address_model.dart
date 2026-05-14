class AddressModel {
  final String cep;
  final String state;
  final String city;
  final String neighborhood;
  final String street;

  AddressModel({
    required this.cep,
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.street,
  });

  factory AddressModel.empty() {
    return AddressModel(
      cep: '',
      state: '',
      city: '',
      neighborhood: '',
      street: '',
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      cep: json['cep'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      street: json['street'] ?? '',
    );
  }
}
