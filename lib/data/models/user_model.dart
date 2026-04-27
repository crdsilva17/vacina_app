class UserModel {
  String id;
  String localId;
  String name;
  String email;
  String birth;
  String cpf;
  int role;

  UserModel({
    required this.id,
    required this.localId,
    required this.name,
    required this.email,
    required this.birth,
    required this.cpf,
    required this.role
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      localId: map['localId'],
      name: map['name'],
      email: map['email'],
      birth: map['birth'],
      cpf: map['cpf'],
      role: map['role'],
    );
  }
}
