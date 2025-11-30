import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItem {
  final CartRepository repository;

  RemoveCartItem({required this.repository});

  Future<List<CartItem>> call(String key) async {
    return await repository.removeCartItem(key: key);
  }
}