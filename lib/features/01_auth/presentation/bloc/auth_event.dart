import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

abstract class AuthEvent {}

// 📧 لاگ ان بٹن دبایا گیا
class LoginRequested extends AuthEvent {
  final LoginParams params;
  LoginRequested({required this.params});
}

// 📝 سائن اپ بٹن دبایا گیا
class SignupRequested extends AuthEvent {
  final SignupParams params;
  SignupRequested({required this.params});
}

// 🌐 سوشل لاگ ان (Google/Facebook)
class SocialLoginRequested extends AuthEvent {
  final String provider; // 'google', 'facebook', 'apple'
  SocialLoginRequested({required this.provider});
}

// 🚪 لاگ آؤٹ
class LogoutRequested extends AuthEvent {}