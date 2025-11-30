import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithSocial {
  final AuthRepository repository;

  LoginWithSocial({required this.repository});

  Future<User> call(SocialLoginParams params) async {
    return await repository.socialLogin(params.provider, params.token);
  }
}

// پیرامیٹرز کو منظم رکھنے کے لیے ہیلپر کلاس
class SocialLoginParams {
  final String provider; // e.g., 'google', 'facebook', 'apple'
  final String token;    // The access token from the provider

  SocialLoginParams({required this.provider, required this.token});
}