import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
// ہم Feature 05 کا OrderModel دوبارہ استعمال کریں گے (Reusability)
import '../../../05_checkout/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  // یوزر کے تمام آرڈرز لائیں
  Future<List<OrderModel>> getMyOrders(int userId, {int page = 1});

  // ایک خاص آرڈر کی تفصیل لائیں
  Future<OrderModel> getOrderDetails(int orderId);

  // آرڈر کینسل کریں (اگر اجازت ہو)
  Future<bool> cancelOrder(int orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  /// 📜 1. میرے آرڈرز کی لسٹ
  @override
  Future<List<OrderModel>> getMyOrders(int userId, {int page = 1}) async {
    try {
      final response = await apiClient.get(
        'wc/v3/orders',
        queryParameters: {
          'customer': userId, // صرف اس یوزر کے آرڈرز
          'per_page': 10,     // ایک صفحے پر 10 آرڈرز
          'page': page,       // صفحہ نمبر
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return (response.data as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 📦 2. سنگل آرڈر کی تفصیل
  @override
  Future<OrderModel> getOrderDetails(int orderId) async {
    try {
      final response = await apiClient.get(
        'wc/v3/orders/$orderId',
        queryParameters: {
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return OrderModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 🚫 3. آرڈر کینسل کرنا
  @override
  Future<bool> cancelOrder(int orderId) async {
    try {
      final response = await apiClient.put(
        'wc/v3/orders/$orderId',
        data: {'status': 'cancelled'},
        queryParameters: {
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      // اگر اسٹیٹس کامیابی سے اپڈیٹ ہو گیا
      return response.data['status'] == 'cancelled';
    } catch (e) {
      return false;
    }
  }
}