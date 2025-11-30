import 'package:goshary_app/core/api/api_client.dart';
import '../models/splash_offer_model.dart';

abstract class SplashRemoteDataSource {
  Future<List<SplashOfferModel>> fetchOffers();
}

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final ApiClient apiClient;

  SplashRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SplashOfferModel>> fetchOffers() async {
    try {
      // اگر آپ کے پاس ورڈپریس میں سلائیڈر کا پلگ ان ہے تو یہاں اس کا URL لکھیں
      // final response = await apiClient.get('wp-json/goshary/v1/slider');

      // فی الحال ہم فرضی ڈیٹا (Mock Data) واپس کر رہے ہیں تاکہ ایپ چلے
      // (جب API بن جائے تو اوپر والا کوڈ استعمال کریں)
      await Future.delayed(const Duration(seconds: 1)); // API جیسی تاخیر

      return [
        SplashOfferModel(
          id: 1,
          imageUrl: "https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=1000&auto=format&fit=crop",
          title: "Discover Premium Products",
          subtitle: "Get 50% Off on New Arrivals",
        ),
        SplashOfferModel(
          id: 2,
          imageUrl: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1000&auto=format&fit=crop",
          title: "Smart Electronics",
          subtitle: "Upgrade your lifestyle today",
        ),
        SplashOfferModel(
          id: 3,
          imageUrl: "https://images.unsplash.com/photo-1522335789203-abd1c1cd9d12?q=80&w=1000&auto=format&fit=crop",
          title: "Fashion Collection",
          subtitle: "Trendy outfits for every season",
        ),
      ];
    } catch (e) {
      rethrow;
    }
  }
}