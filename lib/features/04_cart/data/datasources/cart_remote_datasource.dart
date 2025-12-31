import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/services/di_container.dart';
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

  // --- Helpers ---

  Map<String, dynamic> _getHeaders() {
    final storage = sl<StorageService>();
    final headers = <String, String>{};

    // Cart Token
    final token = storage.getCartToken();
    if (token != null) headers['Cart-Token'] = token;

    // Nonce (سیکیورٹی پاس)
    final nonce = storage.getWcNonce();
    if (nonce != null) headers['X-WC-Store-API-Nonce'] = nonce;

    return headers;
  }

  void _saveHeadersFromResponse(Response response) {
    final storage = sl<StorageService>();

    // Save Token
    if (response.headers.value('cart-token') != null) {
      storage.saveCartToken(response.headers.value('cart-token')!);
    }
    // Save Nonce
    if (response.headers.value('nonce') != null) {
      storage.saveWcNonce(response.headers.value('nonce')!);
      print("✅ Nonce Updated: ${response.headers.value('nonce')}");
    }
  }

  // --- Methods ---

  @override
  Future<List<CartItemModel>> getCart() async {
    try {
      final response = await apiClient.get(
        _cartUrl,
        options: Options(headers: _getHeaders()),
      );
      _saveHeadersFromResponse(response);
      return _parseCartItems(response.data);
    } catch (e) {
      print("Get Cart Error: $e");
      return [];
    }
  }

  @override
  Future<List<CartItemModel>> addToCart({required int productId, required int quantity}) async {
    // 1. پہلی کوشش (First Attempt)
    try {
      return await _performAddToCart(productId, quantity);
    } catch (e) {
      // 2. اگر 401 ایرر آئے (یعنی Nonce غائب یا پرانا ہے)
      if (e is DioException && e.response?.statusCode == 401) {
        print("⚠️ Missing Nonce (401). Fetching new session...");

        // 3. کارٹ کو ریفریش کریں تاکہ نیا Nonce ملے
        // (یہ Get Request نیا Nonce لائے گی اور اسے save کر لے گی)
        await getCart();

        // 4. دوبارہ کوشش کریں (Retry)
        print("🔄 Retrying Add to Cart...");
        return await _performAddToCart(productId, quantity);
      }
      // اگر کوئی اور ایرر ہو تو اسے آگے پھینک دیں
      rethrow;
    }
  }

  // پرائیویٹ فنکشن جو اصل API کال کرتا ہے
  Future<List<CartItemModel>> _performAddToCart(int productId, int quantity) async {
    final response = await apiClient.post(
      '$_cartUrl/add-item',
      data: {'id': productId, 'quantity': quantity},
      options: Options(headers: _getHeaders()),
    );
    _saveHeadersFromResponse(response);
    return _parseCartItems(response.data);
  }

  @override
  Future<List<CartItemModel>> updateCartItem({required String key, required int quantity}) async {
    final response = await apiClient.post(
      '$_cartUrl/update-item',
      data: {'key': key, 'quantity': quantity},
      options: Options(headers: _getHeaders()),
    );
    _saveHeadersFromResponse(response);
    return _parseCartItems(response.data);
  }

  @override
  Future<List<CartItemModel>> removeCartItem({required String key}) async {
    final response = await apiClient.post(
      '$_cartUrl/remove-item',
      data: {'key': key},
      options: Options(headers: _getHeaders()),
    );
    _saveHeadersFromResponse(response);
    return _parseCartItems(response.data);
  }

  @override
  Future<void> clearCart() async {
    try {
      await apiClient.delete(
        '$_cartUrl/items',
        options: Options(headers: _getHeaders()),
      );
    } catch (_) {}
  }

  List<CartItemModel> _parseCartItems(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return [];
    if (data['items'] == null) return [];

    return (data['items'] as List)
        .map((e) => CartItemModel.fromJson(e))
        .toList();
  }
}