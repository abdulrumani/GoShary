import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart({required this.repository});

  Future<List<CartItem>> call(AddToCartParams params) async {
    return await repository.addToCart(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class AddToCartParams {
  final int productId;
  final int quantity;

  AddToCartParams({required this.productId, required this.quantity});
}