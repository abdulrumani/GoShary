import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      // 1. API کو کال کریں
      final UserModel user = await remoteDataSource.login(email, password);

      // 2. اگر لاگ ان کامیاب ہے اور ٹوکن ملا ہے، تو اسے محفوظ کریں
      if (user.token != null && user.token!.isNotEmpty) {
        await storageService.saveUserToken(user.token!);
        await storageService.saveUserId(user.id.toString());
        await storageService.saveUserInfo(user.firstName, user.email);
      }

      return user;
    } catch (e) {
      rethrow; // ایرر کو UI (Bloc) تک جانے دیں
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final UserModel user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      // نوٹ: رجسٹریشن کے بعد اکثر ورڈپریس ٹوکن نہیں دیتا۔
      // اگر ٹوکن ملا تو محفوظ کریں، ورنہ یوزر کو لاگ ان پیج پر بھیجیں گے
      if (user.token != null) {
        await storageService.saveUserToken(user.token!);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> verifyOtp(String phone, String code) async {
    try {
      return await remoteDataSource.verifyOtp(phone, code);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> socialLogin(String provider, String token) async {
    try {
      final user = await remoteDataSource.socialLogin(provider, token);

      if (user.token != null) {
        await storageService.saveUserToken(user.token!);
        await storageService.saveUserInfo(user.firstName, user.email);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> requestPhoneOtp(String phone) async {
    // فی الحال ہم اسے Mock کر رہے ہیں کیونکہ اصلی API نہیں ہے
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}