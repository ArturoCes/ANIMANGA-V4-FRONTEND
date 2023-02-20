class User {
  final String username;
  final String fullName;
  final String email;
  final String accessToken;
  final String? avatar;

  User(
      {required this.username,
      required this.fullName,
      required this.email,
      required this.accessToken,
      this.avatar});

  @override
  String toString() => 'User { name: $fullName, email: $email}';
}
