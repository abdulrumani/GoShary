import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignupUser {
  final AuthRepository repository;

  SignupUser({required this.repository});

  Future<User> call(SignupParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
    );
  }
}

// رجسٹریشن کے لیے تمام ضروری ڈیٹا کو ایک جگہ اکٹھا کرنے والی کلاس
class SignupParams {
  final String name;
  final String email;
  final String password;
  final String phone;

  SignupParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}