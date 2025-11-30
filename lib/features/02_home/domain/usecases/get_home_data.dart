import '../../../../features/03_product_and_category/domain/entities/category.dart';
import '../../../../features/03_product_and_category/domain/entities/product.dart';
import '../entities/home_data.dart'; // BannerEntity
import '../repositories/home_repository.dart';

class GetHomeData {
  final HomeRepository repository;

  GetHomeData({required this.repository});

  Future<HomeDataEntity> call() async {
    // تمام APIs کو ایک ساتھ (Parallel) کال کریں تاکہ وقت بچ سکے
    final results = await Future.wait([
      repository.getBanners(),
      repository.getCategories(),
      repository.getLatestProducts(),
      repository.getSaleProducts(),
      repository.getFeaturedProducts(),
    ]);

    // رزلٹس کو ترتیب سے نکال کر ایک پیکج بنائیں
    return HomeDataEntity(
      banners: results[0] as List<BannerEntity>,
      categories: results[1] as List<Category>,
      latestProducts: results[2] as List<Product>,
      saleProducts: results[3] as List<Product>,
      featuredProducts: results[4] as List<Product>,
    );
  }
}

/// 📦 تمام ہوم ڈیٹا کا ایک پیکج
class HomeDataEntity {
  final List<BannerEntity> banners;
  final List<Category> categories;
  final List<Product> latestProducts;
  final List<Product> saleProducts;
  final List<Product> featuredProducts;

  HomeDataEntity({
    required this.banners,
    required this.categories,
    required this.latestProducts,
    required this.saleProducts,
    required this.featuredProducts,
  });
}