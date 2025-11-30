import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// آپ کی StorageKeys فائل کا لنک
import '../../constants/storage_keys.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor({required this.sharedPreferences});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. شیئرڈ پریفرینسز سے ٹوکن حاصل کریں
    final String? token = sharedPreferences.getString(StorageKeys.userToken);

    // 2. اگر ٹوکن موجود ہے اور خالی نہیں ہے، تو ہیڈر میں شامل کریں
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. ریکویسٹ کو آگے بڑھائیں
    super.onRequest(options, handler);
  }
}