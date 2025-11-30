import '../../domain/entities/splash_offer.dart';

class SplashOfferModel extends SplashOffer {
  SplashOfferModel({
    required super.id,
    required super.imageUrl,
    required super.title,
    required super.subtitle,
  });

  factory SplashOfferModel.fromJson(Map<String, dynamic> json) {
    return SplashOfferModel(
      id: json['id'] ?? 0,
      // اگر API سے تصویر نہ ملے تو پلیس ہولڈر دکھائیں
      imageUrl: json['image_url'] ?? '',
      title: json['title'] ?? 'Welcome to ShopLuxe',
      subtitle: json['subtitle'] ?? 'Premium Shopping Experience',
    );
  }
}