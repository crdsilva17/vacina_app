class UserToken {
  final String token;

  UserToken({required this.token});

  factory UserToken.fromMap(Map<String, dynamic> map){
    return UserToken(token: map['token']);
  }
}