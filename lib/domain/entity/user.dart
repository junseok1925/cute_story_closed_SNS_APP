class User {
  final String id; // uid
  final String nickname;
  final String email;
  final String provider;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.provider,
  });

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      nickname: map['nickname'] ?? '',
      email: map['email'] ?? '',
      provider: map['provider'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nickname': nickname, 'email': email, 'provider': provider};
  }
}
