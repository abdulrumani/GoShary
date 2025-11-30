import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp({required this.repository});

  Future<bool> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.phone, params.code);
  }
}

// پیرامیٹرز کے لیے ہیلپر کلاس
class VerifyOtpParams {
  final String phone;
  final String code;

  VerifyOtpParams({required this.phone, required this.code});
}