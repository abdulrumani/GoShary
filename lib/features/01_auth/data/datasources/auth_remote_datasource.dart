import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
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

  /// 🔐 1. Login User (WordPress JWT Auth)
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login, // e.g., 'jwt-auth/v1/token'
        data: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // JWT پلگ ان عام طور پر ٹوکن اور یوزر کا کچھ ڈیٹا واپس کرتا ہے
        return UserModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Login failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 📝 2. Register User (WooCommerce Customer API)
  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register, // e.g., 'wc/v3/customers'
        data: {
          'email': email,
          'password': password,
          'first_name': name,
          'username': email.split('@')[0], // ای میل سے یوزر نیم بنانا
          'billing': {
            'phone': phone,
            'first_name': name,
            'email': email,
          },
        },
        // نوٹ: رجسٹریشن کے لیے اکثر کنزیومر کیز کی ضرورت ہوتی ہے
        queryParameters: {
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // WooCommerce کسٹمر آبجیکٹ واپس کرتا ہے
        return UserModel.fromWooJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Registration failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 📱 3. OTP Verification (Placeholder)
  /// اس کے لیے آپ کو ورڈپریس میں 'Digits' یا 'Firebase OTP' پلگ ان چاہیے ہوگا
  @override
  Future<bool> verifyOtp(String phone, String code) async {
    // فی الحال ہم اسے Mock کر رہے ہیں (Test کے لیے ہمیشہ true)
    await Future.delayed(const Duration(seconds: 1));
    if (code == "123456") return true; // ٹیسٹنگ کے لیے فکسڈ کوڈ
    return false;
  }

  /// 🌐 4. Social Login (Placeholder)
  @override
  Future<UserModel> socialLogin(String provider, String token) async {
    // یہاں آپ بیک اینڈ پر سوشل لاگ ان کی API کال کریں گے
    await Future.delayed(const Duration(seconds: 2));

    // Mock Response
    return UserModel(
      id: 999,
      email: "social@user.com",
      firstName: "Social User",
      token: "mock_token_123",
      avatarUrl: "",
    );
  }
}