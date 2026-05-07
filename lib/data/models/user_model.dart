class UserModel {
  String id;
  String localId;
  String name;
  String email;
  String birth;
  String cpf;
  String role;

  UserModel({
    required this.id,
    required this.localId,
    required this.name,
    required this.email,
    required this.birth,
    required this.cpf,
    required this.role,
  });

  UserModel.empty()
    : id = '',
      localId = '',
      name = '',
      email = '',
      birth = '',
      cpf = '',
      role = '';

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      localId: map['localId'],
      name: map['nome'],
      email: map['email'],
      birth: map['dataNscto'],
      cpf: map['cpf'],
      role: map['role'],
    );
  }
}
