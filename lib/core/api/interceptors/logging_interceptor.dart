import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('');
      debugPrint('🚀 ----------------- REQUEST ----------------- 🚀');
      debugPrint('🌐 METHOD: ${options.method.toUpperCase()}');
      debugPrint('🔗 URL:    ${options.uri}');

      if (options.headers.isNotEmpty) {
        debugPrint('🔑 HEADERS: ${options.headers}');
      }

      if (options.queryParameters.isNotEmpty) {
        debugPrint('❓ QUERY:   ${options.queryParameters}');
      }

      if (options.data != null) {
        debugPrint('📦 BODY:    ${options.data}');
      }
      debugPrint('-----------------------------------------------');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('');
      debugPrint('✅ ----------------- RESPONSE ----------------- ✅');
      debugPrint('🔢 STATUS:  ${response.statusCode}');
      debugPrint('🔗 URL:     ${response.requestOptions.uri}');

      // ڈیٹا کو پرنٹ کرنا (اگر بہت بڑا ہو تو ڈیبگ پرنٹ اسے ہینڈل کرتا ہے)
      debugPrint('📄 DATA:    ${response.data}');
      debugPrint('-----------------------------------------------');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('');
      debugPrint('❌ ------------------ ERROR ------------------ ❌');
      debugPrint('🔗 URL:     ${err.requestOptions.uri}');
      debugPrint('⚠️ MESSAGE: ${err.message}');

      if (err.response != null) {
        debugPrint('🔢 STATUS:  ${err.response?.statusCode}');
        debugPrint('📄 DATA:    ${err.response?.data}');
      }
      debugPrint('-----------------------------------------------');
    }
    super.onError(err, handler);
  }
}