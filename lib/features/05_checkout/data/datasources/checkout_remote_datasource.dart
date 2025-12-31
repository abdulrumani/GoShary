import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/di_container.dart';
import '../../../../core/services/storage_service.dart';
import '../models/coupon_model.dart';
import '../models/order_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<CouponModel?> applyCoupon(String code);
  Future<OrderModel> placeOrder(OrderModel orderData);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ApiClient apiClient;

  CheckoutRemoteDataSourceImpl({required this.apiClient});

  // 🔐 1. ہیڈرز حاصل کرنے کا فنکشن (Nonce + Token)
  Map<String, dynamic> _getHeaders() {
    final storage = sl<StorageService>();
    final headers = <String, String>{};

    // Cart Token (کارٹ کی پہچان)
    final token = storage.getCartToken();
    if (token != null) {
      headers['Cart-Token'] = token;
    }

    // Nonce (سیکیورٹی پاس کوڈ)
    final nonce = storage.getWcNonce();
    if (nonce != null) {
      headers['X-WC-Store-API-Nonce'] = nonce;
    }

    return headers;
  }

  /// 🎟️ 2. کوپن کوڈ چیک کرنا
  @override
  Future<CouponModel?> applyCoupon(String code) async {
    try {
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
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// 📦 3. آرڈر پلیس کرنا (Place Order)
  @override
  Future<OrderModel> placeOrder(OrderModel order) async {
    try {
      // ڈیٹا کو Store API کے فارمیٹ میں تبدیل کریں
      final data = {
        "payment_method": order.paymentMethod,
        "payment_method_title": order.paymentMethodTitle,
        "set_paid": false,
        "billing_address": {
          // ✅ درست نام: order.billing
          "first_name": order.billing.firstName,
          "last_name": order.billing.lastName,
          "address_1": order.billing.address1,
          "city": order.billing.city,
          "state": order.billing.state,
          "postcode": order.billing.postcode,
          "country": order.billing.country,
          "email": order.billing.email,
          "phone": order.billing.phone,
        },
        "shipping_address": {
          // ✅ درست نام: order.shipping
          "first_name": order.shipping.firstName,
          "last_name": order.shipping.lastName,
          "address_1": order.shipping.address1,
          "city": order.shipping.city,
          "state": order.shipping.state,
          "postcode": order.shipping.postcode,
          "country": order.shipping.country,
        },
      };

      // Store API Checkout Endpoint
      final response = await apiClient.post(
        'wc/store/v1/checkout',
        data: data,
        options: Options(headers: _getHeaders()), // ✅ ہیڈرز لازمی ہیں
      );

      return OrderModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        // ایرر کی تفصیل کنسول میں پرنٹ کریں تاکہ ڈیبگنگ آسان ہو
        print("❌ Checkout Error: ${e.response?.data}");
      }
      rethrow;
    }
  }
}