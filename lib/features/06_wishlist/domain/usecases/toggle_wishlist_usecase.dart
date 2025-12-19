import '../../../03_product_and_category/domain/entities/product.dart'; // Import Product
import '../repositories/wishlist_repository.dart';

class ToggleWishlist {
  final WishlistRepository repository;

  ToggleWishlist({required this.repository});

  // 👇 تبدیلی یہاں ہے
  Future<bool> call(Product product) async {
    return await repository.toggleWishlist(product);
  }
}