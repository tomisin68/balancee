class User {
  final String id;
  final String email;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.token,
  });

  @override
  String toString() {
    return 'User{id: $id, email: $email, token: $token}';
  }
}