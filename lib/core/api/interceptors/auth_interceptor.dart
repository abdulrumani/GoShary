import 'package:dio/dio.dart';
import '../../services/di_container.dart';
import '../../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  // ✅ ہمیں Constructor کی ضرورت نہیں کیونکہ ہم sl() استعمال کر رہے ہیں

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. StorageService حاصل کریں
    final storage = sl<StorageService>();

    // 2. ٹوکن حاصل کریں
    final token = storage.getUserToken();

    // ✅ اہم فکس:
    // ٹوکن صرف تب بھیجیں اگر وہ موجود ہو اور اس میں "mock" کا لفظ نہ ہو
    // یہ 'mock_token_123' اور 'mock_social_token' دونوں کو روک دے گا
    if (token != null &&
        token.isNotEmpty &&
        !token.contains('mock')) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // ریکویسٹ کو آگے بڑھائیں
    handler.next(options);
  }
}