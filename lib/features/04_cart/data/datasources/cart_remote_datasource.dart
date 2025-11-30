import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
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

  // WooCommerce Store API Endpoints
  final String _cartUrl = 'wc/store/v1/cart';

  /// 🛒 1. کارٹ حاصل کرنا
  @override
  Future<List<CartItemModel>> getCart() async {
    try {
      final response = await apiClient.get(_cartUrl);
      return _parseCartItems(response.data);
    } catch (e) {
      // اگر کارٹ خالی ہے یا نیا سیشن ہے
      return [];
    }
  }

  /// ➕ 2. کارٹ میں آئٹم شامل کرنا
  @override
  Future<List<CartItemModel>> addToCart({required int productId, required int quantity}) async {
    try {
      final response = await apiClient.post(
        '$_cartUrl/add-item',
        data: {
          'id': productId,
          'quantity': quantity,
        },
      );
      return _parseCartItems(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 🔄 3. کارٹ آئٹم اپڈیٹ کرنا (Quantity change)
  @override
  Future<List<CartItemModel>> updateCartItem({required String key, required int quantity}) async {
    try {
      final response = await apiClient.post(
        '$_cartUrl/update-item',
        data: {
          'key': key,
          'quantity': quantity,
        },
      );
      return _parseCartItems(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 🗑️ 4. کارٹ سے آئٹم ہٹانا
  @override
  Future<List<CartItemModel>> removeCartItem({required String key}) async {
    try {
      final response = await apiClient.post(
        '$_cartUrl/remove-item',
        data: {
          'key': key,
        },
      );
      return _parseCartItems(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 🧹 5. کارٹ خالی کرنا
  @override
  Future<void> clearCart() async {
    try {
      await apiClient.delete('$_cartUrl/items');
    } catch (e) {
      // Ignore errors on clear
    }
  }

  // --- Helper Function ---
  List<CartItemModel> _parseCartItems(dynamic data) {
    if (data['items'] == null) return [];

    return (data['items'] as List)
        .map((e) => CartItemModel.fromJson(e))
        .toList();
  }
}