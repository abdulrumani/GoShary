import '../entities/category.dart';
import '../entities/product.dart';
import '../entities/review.dart';

abstract class ProductRepository {
  // ایک پروڈکٹ کی مکمل تفصیل لائیں
  Future<Product> getProductDetails(String id);

  // پروڈکٹ کے ریویوز لائیں
  Future<List<Review>> getProductReviews(String productId);

  // تمام کیٹیگریز لائیں
  Future<List<Category>> getAllCategories();

  // متعلقہ پروڈکٹس (Related Products) لائیں
  Future<List<Product>> getRelatedProducts(String categoryId);
}