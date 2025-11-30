import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCart {
  final CartRepository repository;

  GetCart({required this.repository});

  Future<List<CartItem>> call() async {
    return await repository.getCart();
  }
}