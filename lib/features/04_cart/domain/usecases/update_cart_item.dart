import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItem {
  final CartRepository repository;

  UpdateCartItem({required this.repository});

  Future<List<CartItem>> call(UpdateCartParams params) async {
    return await repository.updateCartItem(
      key: params.key,
      quantity: params.quantity,
    );
  }
}

class UpdateCartParams {
  final String key; // Cart Item Key
  final int quantity;

  UpdateCartParams({required this.key, required this.quantity});
}