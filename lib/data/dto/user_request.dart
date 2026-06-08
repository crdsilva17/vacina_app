class UserRequest {
  final String email;
  final String name;
  final String local;
  final String birth;

  const UserRequest({
    required this.email,
    required this.name,
    required this.local,
    required this.birth,
  });

  factory UserRequest.fromMap(Map map) {
    return UserRequest(
      email: map['email'],
      name: map['name'],
      local: map['local'],
      birth: map['birth'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'nome': name, 'local': local, 'dataNscto': birth};
  }
}
