import 'dart:convert'; // JSON کے لیے
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/services/di_container.dart';
import '../../../03_product_and_category/data/models/product_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<ProductModel>> getWishlist();
  Future<bool> toggleWishlist(ProductModel product); // نوٹ: اب ہم پورا پروڈکٹ بھیجیں گے
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiClient apiClient;
  WishlistRemoteDataSourceImpl({required this.apiClient});

  final String _key = 'local_wishlist_data';

  @override
  Future<List<ProductModel>> getWishlist() async {
    final prefs = sl<SharedPreferences>();
    final jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  // ⚠️ نوٹ: میں نے پیرامیٹر کو 'int productId' سے 'ProductModel product' میں بدلا ہے
  // کیونکہ لوکل اسٹوریج کے لیے ہمیں پورا ڈیٹا محفوظ کرنا ہے۔
  Future<bool> toggleWishlist(ProductModel product) async {
    final prefs = sl<SharedPreferences>();
    List<ProductModel> currentList = await getWishlist();

    // چیک کریں کہ پہلے سے موجود ہے یا نہیں
    final index = currentList.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      // اگر موجود ہے تو ہٹا دیں
      currentList.removeAt(index);
    } else {
      // اگر نہیں ہے تو شامل کریں
      currentList.add(product);
    }

    // واپس سیو کریں
    // ہمیں ماڈل کو JSON میں بدلنا ہوگا (ProductModel میں toJson ہونا ضروری ہے)
    // چونکہ ہم نے ProductModel میں toJson نہیں بنایا تھا، ہمیں وہ بھی شامل کرنا پڑے گا۔
    // فی الحال ہم ایک جگاڑ (workaround) کرتے ہیں: صرف آئی ڈی محفوظ نہیں کر سکتے کیونکہ UI کو ڈیٹا چاہیے۔

    // ایک سادہ حل:
    final encoded = json.encode(currentList.map((e) => _productToJson(e)).toList());
    await prefs.setString(_key, encoded);

    return true;
  }

  // Helper to convert ProductModel back to JSON
  Map<String, dynamic> _productToJson(ProductModel p) {
    return {
      'id': p.id,
      'name': p.name,
      'price': p.price,
      'regular_price': p.regularPrice,
      'sale_price': p.salePrice,
      'on_sale': p.onSale,
      'average_rating': p.rating,
      'rating_count': p.reviewCount,
      'images': [{'src': p.imageUrl}], // Simplified
      'description': p.description,
    };
  }
}