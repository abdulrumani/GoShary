import '../../../03_product_and_category/domain/entities/product.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlist {
  final WishlistRepository repository;

  GetWishlist({required this.repository});

  Future<List<Product>> call() async {
    return await repository.getWishlist();
  }
}