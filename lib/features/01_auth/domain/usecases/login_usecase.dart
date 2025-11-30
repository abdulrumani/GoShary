import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser({required this.repository});

  // call فنکشن کو ہم براہ راست کلاس کے نام سے بلا سکتے ہیں
  // مثال: await loginUser(params);
  Future<User> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

// پیرامیٹرز کو منظم رکھنے کے لیے ایک چھوٹی کلاس
class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}