import '../../../../features/03_product_and_category/domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getWishlist() async {
    try {
      // ریموٹ ڈیٹا سورس ProductModel کی لسٹ دیتا ہے
      // چونکہ ProductModel، Product کو extend کرتا ہے، یہ سیدھا return ہو سکتا ہے
      return await remoteDataSource.getWishlist();
    } catch (e) {
      // اگر کوئی ایرر آئے (جیسے نیٹ ورک ایشو)، تو فی الحال خالی لسٹ واپس کریں
      return [];
    }
  }

  @override
  Future<bool> toggleWishlist(int productId) async {
    try {
      return await remoteDataSource.toggleWishlist(productId);
    } catch (e) {
      // اگر ایکشن فیل ہو جائے تو فرض کریں کہ کچھ نہیں ہوا (false)
      return false;
    }
  }
}