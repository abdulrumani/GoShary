import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

// نوٹ: یہ ماڈلز ہم اگلے سٹیپ میں بنائیں گے
import '../../../../features/03_product_and_category/data/models/category_model.dart';
import '../../../../features/03_product_and_category/data/models/product_model.dart';
import '../models/home_data_model.dart'; // (Banners کے لیے)

abstract class HomeRemoteDataSource {
  Future<List<BannerModel>> getBanners();
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getLatestProducts();
  Future<List<ProductModel>> getSaleProducts();
  Future<List<ProductModel>> getFeaturedProducts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  // 1. Banners (Sliders) [cite: 65-66]
  // چونکہ WooCommerce میں ڈیفالٹ سلائیڈر نہیں ہوتا، ہم فی الحال Mock Data استعمال کریں گے
  // یا اگر آپ نے کوئی پلگ ان لگایا ہے تو اس کا API Endpoint یہاں استعمال کریں۔
  @override
  Future<List<BannerModel>> getBanners() async {
    // اصلی API کال (اگر دستیاب ہو):
    // final response = await apiClient.get('wp-json/goshary/v1/sliders');

    // Mock Data for UI Testing
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      BannerModel(
        id: 1,
        imageUrl: "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1000&auto=format&fit=crop",
        title: "Summer Sale",
        subtitle: "Up to 50% Off",
      ),
      BannerModel(
        id: 2,
        imageUrl: "https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=1000&auto=format&fit=crop",
        title: "New Collection",
        subtitle: "Discover the latest trends",
      ),
    ];
  }

  // 2. Categories (Main Categories) [cite: 69-80]
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.categories,
        queryParameters: {
          'per_page': 10, // صرف ٹاپ 10 کیٹیگریز
          'parent': 0,    // صرف مین کیٹیگریز (Sub-categories نہیں)
          'hide_empty': true, // خالی کیٹیگریز نہ دکھائیں
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

  // 3. Latest Products (New Arrivals) [cite: 81-90]
  @override
  Future<List<ProductModel>> getLatestProducts() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.products,
        queryParameters: {
          'per_page': 10,
          'orderby': 'date', // تاریخ کے حساب سے (نئی پہلے)
          'order': 'desc',
          'status': 'publish',
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // 4. Sale Products (Special Offers) [cite: 91-96]
  @override
  Future<List<ProductModel>> getSaleProducts() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.products,
        queryParameters: {
          'per_page': 10,
          'on_sale': true, // صرف وہ جن پر سیل لگی ہے
          'status': 'publish',
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // 5. Featured/Trending Products [cite: 97-104]
  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.products,
        queryParameters: {
          'per_page': 10,
          'featured': true, // صرف وہ جو WooCommerce میں 'Featured' مارک ہیں
          'status': 'publish',
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      return (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}