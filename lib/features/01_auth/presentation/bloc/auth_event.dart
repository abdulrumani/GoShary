import 'package:equatable/equatable.dart'; // ✅ Equatable import کریں
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

// ✅ Parent Class میں const اور Equatable شامل کریں
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// 📧 لاگ ان بٹن دبایا گیا
class LoginRequested extends AuthEvent {
  final LoginParams params;
  const LoginRequested({required this.params});

  @override
  List<Object> get props => [params];
}

// 📝 سائن اپ بٹن دبایا گیا
class SignupRequested extends AuthEvent {
  final SignupParams params;
  const SignupRequested({required this.params});

  @override
  List<Object> get props => [params];
}

// 🚪 لاگ آؤٹ
class LogoutRequested extends AuthEvent {}

// 🌐 سوشل لاگ ان (Google/Facebook/Apple)
// ✅ یہ کلاس اب بالکل ٹھیک کام کرے گی
class LoginWithSocialEvent extends AuthEvent {
  final String provider; // 'google', 'facebook', or 'apple'

  const LoginWithSocialEvent({required this.provider});

  @override
  List<Object> get props => [provider];
}