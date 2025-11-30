import '../../../03_product_and_category/domain/entities/product.dart';

abstract class WishlistRepository {
  // وش لسٹ کی لسٹ لائیں
  Future<List<Product>> getWishlist();

  // وش لسٹ میں شامل کریں یا نکالیں (Toggle)
  Future<bool> toggleWishlist(int productId);
}