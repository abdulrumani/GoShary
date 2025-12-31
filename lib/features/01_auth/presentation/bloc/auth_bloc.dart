import 'package:flutter_bloc/flutter_bloc.dart';
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

    // 1. Email Login Handler
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUser(event.params);
      result.fold(
            (failure) => emit(AuthFailure(message: failure.message)),
            (user) => emit(AuthSuccess(user: user)),
      );
    });

    // 2. Signup Handler
    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signupUser(event.params);
      result.fold(
            (failure) => emit(AuthFailure(message: failure.message)),
            (user) => emit(AuthSuccess(user: user)),
      );
    });

    // 3. Social Login Handler (✅ FIXED HERE)
    on<LoginWithSocialEvent>((event, emit) async {
      emit(AuthLoading());

      // ہم ٹوکن خالی بھیج رہے ہیں کیونکہ RemoteDataSource خود Google سے ٹوکن لے گا
      final result = await loginWithSocial(
        SocialLoginParams(provider: event.provider, token: ''),
      );

      result.fold(
            (failure) => emit(AuthFailure(message: failure.message)),
            (user) => emit(AuthSuccess(user: user)),
      );
    });

    // 4. Logout Handler
    on<LogoutRequested>((event, emit) async {
      await storageService.logout();
      emit(AuthInitial());
    });
  }
}