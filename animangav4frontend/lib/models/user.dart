class User {
  final String name;
  final String email;
  final String accessToken;
  final String? image;

  User(
      {required this.name,
      required this.email,
      required this.accessToken,
      this.image});

  @override
  String toString() => 'User { name: $name, email: $email}';
}
