import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.id,
    required super.reviewerName,
    required super.reviewContent,
    required super.rating,
    required super.date,
    required super.avatarUrl,
    required super.isVerified,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    // WooCommerce اوتار کے مختلف سائز بھیجتا ہے ('24', '48', '96')
    String avatar = '';
    if (json['reviewer_avatar_urls'] != null) {
      avatar = json['reviewer_avatar_urls']['96'] ?? '';
    }

    return ReviewModel(
      id: json['id'] ?? 0,
      reviewerName: json['reviewer'] ?? 'Anonymous',
      // WooCommerce اکثر HTML بھیجتا ہے (e.g., <p>Good!</p>)
      // UI میں ہم 'flutter_html' استعمال کریں گے، فی الحال یہاں Raw String محفوظ کر رہے ہیں
      reviewContent: json['review'] ?? '',
      rating: json['rating'] ?? 0,
      date: json['date_created'] ?? '',
      avatarUrl: avatar,
      isVerified: json['verified'] ?? false,
    );
  }
}