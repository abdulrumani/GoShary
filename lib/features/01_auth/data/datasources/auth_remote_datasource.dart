import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/di_container.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<bool> verifyOtp(String phone, String code);
  Future<UserModel> socialLogin(String provider, String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  /// 🔐 1. Login User (JWT Auth)
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login, // 'jwt-auth/v1/token'
        data: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // ٹوکن اور ڈیٹا نکالیں
        final token = data['token'];
        final userEmail = data['user_email'];
        final userDisplayName = data['user_display_name'];

        // ✅ ٹوکن لوکل اسٹوریج میں محفوظ کریں (بہت ضروری)
        final storage = sl<StorageService>();
        await storage.saveUserToken(token);
        await storage.saveUserInfo(userDisplayName, userEmail);

        return UserModel(
          id: 0,
          email: userEmail,
          firstName: userDisplayName,
          token: token, // ماڈل میں ٹوکن سیٹ کریں
          avatarUrl: '',
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Login failed: Invalid Credentials',
        );
      }
    } catch (e) {
      print("Login Error: $e");
      rethrow;
    }
  }

  /// 📝 2. Register User (WooCommerce API)
  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register, // 'wc/v3/customers'
        data: {
          'email': email,
          'password': password,
          'first_name': name,
          'username': email.split('@')[0],
          'billing': {
            'first_name': name,
            'email': email,
            'phone': phone,
          },
        },
        queryParameters: {
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      if (response.statusCode == 201) {
        // رجسٹریشن کامیاب! اب خودکار لاگ ان کروائیں تاکہ ٹوکن مل جائے
        return await login(email, password);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Registration failed',
        );
      }
    } catch (e) {
      if (e is DioException) {
        print("Signup Error: ${e.response?.data}");
      }
      rethrow;
    }
  }

  /// 📱 3. OTP Verification (Mock)
  @override
  Future<bool> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code == "123456") return true;
    return false;
  }

  /// 🌐 4. Social Login (Mock)
  @override
  Future<UserModel> socialLogin(String provider, String token) async {
    await Future.delayed(const Duration(seconds: 2));
    // فی الحال یہ ڈمی ڈیٹا ہے، بعد میں Firebase سے جوڑیں گے
    return UserModel(
      id: 999,
      email: "social@user.com",
      firstName: "Social User",
      token: "mock_social_token",
      avatarUrl: "",
    );
  }
}