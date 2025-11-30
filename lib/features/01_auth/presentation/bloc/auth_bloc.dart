import 'package:flutter_bloc/flutter_bloc.dart';

// Core & UseCases
import '../../../../core/services/storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/login_with_social_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SignupUser signupUser;
  final LoginWithSocial loginWithSocial;
  final StorageService storageService;

  AuthBloc({
    required this.loginUser,
    required this.signupUser,
    required this.loginWithSocial,
    required this.storageService,
  }) : super(AuthInitial()) {

    // 1. Login Handler
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUser(event.params);
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    // 2. Signup Handler
    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signupUser(event.params);
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    // 3. Social Login Handler
    on<SocialLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // نوٹ: اصلی سوشل لاگ ان میں ہمیں پہلے Google/Facebook SDK سے ٹوکن لینا ہوتا ہے۔
        // یہاں ہم فرض کر رہے ہیں کہ ٹوکن مل گیا ہے۔
        // (مکمل کوڈ میں آپ یہاں GoogleSignIn().signIn() کال کریں گے)

        const fakeToken = "sample_social_token_123";

        final user = await loginWithSocial(
          SocialLoginParams(provider: event.provider, token: fakeToken),
        );
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    // 4. Logout Handler
    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await storageService.logout();
      emit(Unauthenticated());
    });
  }
}