import 'package:intl/intl.dart';

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

  Map<String, dynamic> toMap() {
    DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dataNsc);
    String dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    return {
      'localId': localId,
      'nome': name,
      'email': email,
      'senha': passwd,
      'dataNscto': dateFormat,
      'cpf': cpf,
      'role': role,
    };
  }
}
