import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCart();

  Future<List<CartItem>> addToCart({required int productId, required int quantity});

  Future<List<CartItem>> updateCartItem({required String key, required int quantity});

  Future<List<CartItem>> removeCartItem({required String key});

  Future<void> clearCart();
}