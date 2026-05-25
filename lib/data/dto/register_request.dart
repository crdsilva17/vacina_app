class RegisterRequest {
  final String name;
  final String cpf;
  final String dataNsc;
  final String localId;
  final String email;
  final String passwd;
  final String role = 'USER';

  RegisterRequest({
    required this.name,
    required this.cpf,
    required this.dataNsc,
    required this.localId,
    required this.email,
    required this.passwd,
  });

  factory RegisterRequest.fromMap(Map<String, dynamic> map) {
    return RegisterRequest(
      name: map['name'],
      cpf: map['cpf'],
      dataNsc: map['dataNsc'],
      localId: map['localId'],
      email: map['email'],
      passwd: map['passwd'],
    );
  }
}
