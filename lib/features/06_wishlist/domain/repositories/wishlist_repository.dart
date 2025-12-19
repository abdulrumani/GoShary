import '../../../03_product_and_category/domain/entities/product.dart';

abstract class WishlistRepository {
  Future<List<Product>> getWishlist();

  // 👇 تبدیلی یہاں ہے: int کی جگہ Product
  Future<bool> toggleWishlist(Product product);
}