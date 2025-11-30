import '../entities/user.dart';

abstract class AuthRepository {

  Future<User> login(String email, String password);

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<bool> verifyOtp(String phone, String code);

  Future<User> socialLogin(String provider, String token);

  Future<bool> requestPhoneOtp(String phone);
}