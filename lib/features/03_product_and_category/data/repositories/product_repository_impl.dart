import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Product> getProductDetails(String id) async {
    try {
      return await remoteDataSource.getProductDetails(id);
    } catch (e) {
      rethrow; // ایرر کو Bloc تک جانے دیں تاکہ وہ UI پر دکھا سکے
    }
  }

  @override
  Future<List<Review>> getProductReviews(String productId) async {
    try {
      return await remoteDataSource.getProductReviews(productId);
    } catch (e) {
      return []; // اگر ایرر آئے تو خالی لسٹ بھیجیں (ریویوز کے بغیر بھی پیج چل سکتا ہے)
    }
  }

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      return await remoteDataSource.getAllCategories();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Product>> getRelatedProducts(String categoryId) async {
    try {
      return await remoteDataSource.getRelatedProducts(categoryId);
    } catch (e) {
      return [];
    }
  }
}