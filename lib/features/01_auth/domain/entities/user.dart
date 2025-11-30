class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String? token; // لاگ ان کے بعد یہ ٹوکن ملے گا

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.token,
  });
}