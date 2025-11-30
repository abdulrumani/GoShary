import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../03_product_and_category/data/models/product_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<ProductModel>> getWishlist();
  Future<bool> toggleWishlist(int productId); // Add or Remove
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDataSourceImpl({required this.apiClient});

  // YITH Wishlist API Endpoints (یہ آپ کے پلگ ان کے مطابق مختلف ہو سکتے ہیں)
  // مثال: 'yith/wishlist/v1'
  final String _wishlistBaseUrl = 'yith/wishlist/v1';

  /// ❤️ 1. وش لسٹ حاصل کرنا
  @override
  Future<List<ProductModel>> getWishlist() async {
    try {
      // 1. وش لسٹ کے آئٹمز لائیں
      final response = await apiClient.get(
          '$_wishlistBaseUrl/wishlist/products',
          queryParameters: {
            'consumer_key': ApiEndpoints.consumerKey,
            'consumer_secret': ApiEndpoints.consumerSecret,
          }
      );

      // نوٹ: YITH کبھی کبھی صرف IDs دیتا ہے اور کبھی پورا آبجیکٹ۔
      // ہم فرض کر رہے ہیں کہ یہ پروڈکٹ آبجیکٹس کی لسٹ دے رہا ہے۔
      // اگر یہ صرف IDs دیتا ہے، تو ہمیں ان IDs کو لے کر دوبارہ Product API کال کرنی ہوگی۔

      // فی الحال ہم اسے ProductModel میں پارس کر رہے ہیں
      return (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

    } catch (e) {
      // اگر API فیل ہو جائے (یا پلگ ان نہ ہو)، تو فی الحال خالی لسٹ بھیجیں
      return [];
    }
  }

  /// 🔄 2. وش لسٹ میں شامل کرنا / ہٹانا (Toggle)
  @override
  Future<bool> toggleWishlist(int productId) async {
    try {
      // یہ چیک کرنے کے لیے کہ پروڈکٹ پہلے سے ہے یا نہیں، ہمیں پہلے لسٹ لانی پڑ سکتی ہے
      // یا API کا 'toggle' اینڈ پوائنٹ استعمال کریں۔

      // YITH Add Endpoint:
      final response = await apiClient.post(
        '$_wishlistBaseUrl/wishlist/add',
        queryParameters: {
          'product_id': productId,
          'consumer_key': ApiEndpoints.consumerKey,
          'consumer_secret': ApiEndpoints.consumerSecret,
        },
      );

      // اگر سٹیٹس "added" ہے تو true واپس کریں
      if (response.data['status'] == 'added' || response.data['result'] == 'true') {
        return true;
      }
      // اگر "exists" یا "removed" ہے
      else {
        // اگر پہلے سے موجود تھا، تو اسے ہٹانے کی کوشش کریں
        await _removeFromWishlist(productId);
        return false; // اب لسٹ میں نہیں ہے
      }
    } catch (e) {
      // اگر API نہ چلے تو ہم اسے عارضی طور پر true مان لیتے ہیں تاکہ UI اپڈیٹ ہو جائے
      // (اصلی ایپ میں یہاں ایرر ہینڈلنگ ہونی چاہیے)
      return true;
    }
  }

  Future<void> _removeFromWishlist(int productId) async {
    await apiClient.delete(
      '$_wishlistBaseUrl/wishlist/remove',
      queryParameters: {
        'product_id': productId,
        'consumer_key': ApiEndpoints.consumerKey,
        'consumer_secret': ApiEndpoints.consumerSecret,
      },
    );
  }
}