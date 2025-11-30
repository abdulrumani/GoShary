import '../../domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// ✅ کامیابی (لاگ ان/سائن اپ کے بعد)
class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess({required this.user});
}

// ❌ ناکامی (ایرر میسج دکھانے کے لیے)
class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

// 🚪 لاگ آؤٹ ہونے پر
class Unauthenticated extends AuthState {}