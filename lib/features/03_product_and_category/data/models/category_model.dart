import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.count,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // WooCommerce میں کبھی کبھی امیج null ہوتی ہے، یا empty array ہوتی ہے
    String img = '';
    if (json['image'] != null && json['image'] is Map) {
      img = json['image']['src'] ?? '';
    }

    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: img,
      description: json['description'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}