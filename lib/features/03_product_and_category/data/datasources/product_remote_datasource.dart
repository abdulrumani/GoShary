import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// یہ ماڈلز ہمیں ابھی بنانے ہیں (اگر نہیں بنے تو ایرر آئے گا)
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProductDetails(String id);
  Future<List<ReviewModel>> getProductReviews(String productId);
  Future<List<CategoryModel>> getAllCategories();
  Future<List<ProductModel>> getRelatedProducts(String categoryId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  /// 📦 1. سنگل پروڈکٹ کی تفصیل (Get Single Product)
  @override
  Future<ProductModel> getProductDetails(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.products}/$id',
        queryParameters: {
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return ProductModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// ⭐ 2. پروڈکٹ کے ریویوز (Get Reviews)
  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      final response = await apiClient.get(
        'wc/v3/products/reviews', // Endpoint usually differs slightly based on setup
        queryParameters: {
          'product': productId,
          'status': 'approved',
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return (response.data as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    } catch (e) {
      // اگر کوئی ریویو نہ ملے تو خالی لسٹ واپس کریں
      return [];
    }
  }

  /// 📂 3. تمام کیٹیگریز (Get All Categories)
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.categories,
        queryParameters: {
          'per_page': 100, // زیادہ سے زیادہ کیٹیگریز لائیں
          'hide_empty': true,
          'orderby': 'count', // سب سے زیادہ آئٹمز والی پہلے
          'order': 'desc',
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 🔗 4. متعلقہ پروڈکٹس (Related Products)
  /// یہ ہم اسی کیٹیگری کی دوسری پروڈکٹس لا کر دکھائیں گے
  @override
  Future<List<ProductModel>> getRelatedProducts(String categoryId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.products,
        queryParameters: {
          'category': categoryId,
          'per_page': 5, // صرف 5 متعلقہ آئٹمز کافی ہیں
          'exclude': [], // موجودہ پروڈکٹ کو یہاں سے نکالنا بہتر ہے (Logic Bloc میں ہوگا)
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}