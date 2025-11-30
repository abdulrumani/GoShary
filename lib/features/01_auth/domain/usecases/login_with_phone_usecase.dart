import '../repositories/auth_repository.dart';

class LoginWithPhone {
  final AuthRepository repository;

  LoginWithPhone({required this.repository});

  Future<bool> call(String phone) async {
    // یہ فنکشن Repository کو کہے گا کہ اس نمبر پر OTP بھیجو
    return await repository.requestPhoneOtp(phone);
  }
}