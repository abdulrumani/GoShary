import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// یہ فائلز ہم نیچے اسی جواب میں بنائیں گے تاکہ ایرر نہ آئے
import '../constants/api_endpoints.dart';
import '../constants/storage_keys.dart';

class ApiClient {
  final SharedPreferences sharedPreferences;
  late Dio _dio;

  ApiClient({required this.sharedPreferences}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // --- Interceptors (چوکیدار) ---
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 1. زبان (Language) شامل کرنا
          // WPML/Polylang عام طور پر URL پیرامیٹر (?lang=ar) کو پسند کرتے ہیں
          final String langCode = sharedPreferences.getString(StorageKeys.appLang) ?? 'en';
          options.queryParameters.addAll({'lang': langCode});

          // 2. ٹوکن (Auth Token) شامل کرنا
          // اگر یوزر لاگ ان ہے تو ٹوکن ہیڈر میں ڈال دیں
          final String? token = sharedPreferences.getString(StorageKeys.userToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // یہاں ہم گلوبل ایرر ہینڈلنگ کر سکتے ہیں
          debugPrint("❌ API Error: ${error.message}");
          debugPrint("❌ URL: ${error.requestOptions.path}");
          return handler.next(error);
        },
      ),
    );

    // 3. لاگنگ (صرف ڈیبگ موڈ میں)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }
  }

  // --- Generic HTTP Methods ---

  Future<Response> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on SocketException catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: uri),
        error: "No Internet Connection",
        type: DioExceptionType.connectionError,
      );
    } on FormatException catch (_) {
      throw DioException(
        requestOptions: RequestOptions(path: uri),
        error: "Bad Response Format",
        type: DioExceptionType.badResponse,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}