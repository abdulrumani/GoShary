import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/coupon_model.dart';
import '../models/order_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<CouponModel?> applyCoupon(String code);
  Future<OrderModel> placeOrder(OrderModel orderData);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ApiClient apiClient;

  CheckoutRemoteDataSourceImpl({required this.apiClient});

  /// 🎟️ 1. کوپن کوڈ چیک کرنا
  @override
  Future<CouponModel?> applyCoupon(String code) async {
    try {
      // WooCommerce API میں کوپن کوڈ سے سرچ کریں
      final response = await apiClient.get(
        'wc/v3/coupons',
        queryParameters: {
          'code': code,
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      final List data = response.data;
      if (data.isNotEmpty) {
        return CouponModel.fromJson(data.first);
      }
      return null; // اگر کوپن نہ ملے
    } catch (e) {
      rethrow;
    }
  }

  /// 📦 2. آرڈر پلیس کرنا (Place Order)
  @override
  Future<OrderModel> placeOrder(OrderModel orderData) async {
    try {
      final response = await apiClient.post(
        'wc/v3/orders',
        data: orderData.toJson(), // OrderModel کو JSON بنا کر بھیجیں
        queryParameters: {
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      if (response.statusCode == 201) {
        return OrderModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: "Failed to place order",
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}