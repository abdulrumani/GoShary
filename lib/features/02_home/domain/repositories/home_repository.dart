// یہ Entities ہم اگلے سٹیپ میں (فیچر 03) میں بنائیں گے
import '../../../../features/03_product_and_category/domain/entities/category.dart';
import '../../../../features/03_product_and_category/domain/entities/product.dart';
import '../entities/home_data.dart'; // BannerEntity

abstract class HomeRepository {
  Future<List<BannerEntity>> getBanners();

  Future<List<Category>> getCategories();

  Future<List<Product>> getLatestProducts();

  Future<List<Product>> getSaleProducts();

  Future<List<Product>> getFeaturedProducts();
}