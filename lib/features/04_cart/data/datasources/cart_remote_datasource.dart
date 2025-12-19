import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/services/di_container.dart'; // StorageService تک رسائی کے لیے
import '../../../../core/services/storage_service.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCart();
  Future<List<CartItemModel>> addToCart({required int productId, required int quantity});
  Future<List<CartItemModel>> updateCartItem({required String key, required int quantity});
  Future<List<CartItemModel>> removeCartItem({required String key});
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  final String _cartUrl = 'wc/store/v1/cart';

  // 👇 ہیڈرز حاصل کرنے کا فنکشن
  Map<String, dynamic> _getHeaders() {
    final storage = sl<StorageService>();
    final token = storage.getCartToken();
    if (token != null) {
      return {'Cart-Token': token}; // اگر ٹوکن موجود ہے تو بھیجیں
    }
    return {};
  }

  // 👇 ریسپانس سے ٹوکن محفوظ کرنے کا فنکشن
  void _saveTokenFromResponse(Response response) {
    // WooCommerce ہیڈر میں 'cart-token' بھیجتا ہے
    final token = response.headers.value('cart-token');
    if (token != null) {
      sl<StorageService>().saveCartToken(token);
    }
  }

  @override
  Future<List<CartItemModel>> getCart() async {
    try {
      final response = await apiClient.get(
        _cartUrl,
        options: Options(headers: _getHeaders()), // ہیڈر بھیجیں
      );
      return _parseCartItems(response.data);
    } catch (e) {
      print("Get Cart Error: $e");
      return [];
    }
  }

  @override
  Future<List<CartItemModel>> addToCart({required int productId, required int quantity}) async {
    try {
      final response = await apiClient.post(
        '$_cartUrl/add-item',
        data: {'id': productId, 'quantity': quantity},
        options: Options(headers: _getHeaders()), // ہیڈر بھیجیں
      );

      _saveTokenFromResponse(response); // ✅ نیا ٹوکن محفوظ کریں

      return _parseCartItems(response.data);
    } catch (e) {
      print("Add to Cart Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<CartItemModel>> updateCartItem({required String key, required int quantity}) async {
    try {
      final response = await apiClient.post(
        '$_cartUrl/update-item',
        data: {'key': key, 'quantity': quantity},
        options: Options(headers: _getHeaders()),
      );
      return _parseCartItems(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CartItemModel>> removeCartItem({required String key}) async {
    try {
      final response = await apiClient.post(
        '$_cartUrl/remove-item',
        data: {'key': key},
        options: Options(headers: _getHeaders()),
      );
      return _parseCartItems(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await apiClient.delete(
        '$_cartUrl/items',
        options: Options(headers: _getHeaders()),
      );
    } catch (e) {
      // Ignore
    }
  }

  List<CartItemModel> _parseCartItems(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return [];
    if (data['items'] == null) return [];

    return (data['items'] as List)
        .map((e) => CartItemModel.fromJson(e))
        .toList();
  }
}