class UserToken {
  final String token;

  UserToken({required this.token});

  factory UserToken.fromMap(Map<String, dynamic> ret){
    return UserToken(token: ret['token'].toString());
  }
}