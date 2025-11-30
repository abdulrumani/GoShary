import '../../domain/entities/home_data.dart';

class BannerModel extends BannerEntity {
  BannerModel({
    required super.id,
    required super.imageUrl,
    required super.title,
    required super.subtitle,
    super.link,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      // ورڈپریس اکثر تصاویر کو 'guid' یا 'source_url' میں بھیجتا ہے، اس لیے محفوظ چیک
      imageUrl: json['image_url'] ?? json['guid']?['rendered'] ?? '',
      title: json['title']?['rendered'] ?? json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      link: json['link'] ?? '',
    );
  }

  // ٹیسٹنگ کے لیے Mock Data بنانے کے لیے آسان کنسٹرکٹر
  factory BannerModel.mock() {
    return BannerModel(
      id: 1,
      imageUrl: 'https://via.placeholder.com/800x400',
      title: 'Test Banner',
      subtitle: 'Test Subtitle',
    );
  }
}