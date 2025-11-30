import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.shortDescription,
    required super.price,
    required super.regularPrice,
    required super.salePrice,
    required super.onSale,
    required super.imageUrl,
    required super.galleryImages,
    required super.rating,
    required super.reviewCount,
    required super.stockStatus,
    required super.attributes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // 1. Images Parsing
    String mainImage = '';
    List<String> gallery = [];

    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      // پہلی تصویر کو مین امیج بنائیں
      mainImage = json['images'][0]['src'] ?? '';
      // باقی سب کو گیلری میں ڈالیں
      gallery = (json['images'] as List)
          .map((e) => e['src'].toString())
          .toList();
    }

    // 2. Attributes Parsing (Color, Size)
    List<ProductAttribute> parsedAttributes = [];
    if (json['attributes'] != null) {
      parsedAttributes = (json['attributes'] as List).map((attr) {
        return ProductAttribute(
          name: attr['name'] ?? '',
          options: (attr['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
        );
      }).toList();
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      // HTML Tags کو ہٹانا بہتر ہوتا ہے، لیکن فی الحال ہم اسے Raw String رکھ رہے ہیں
      // UI میں ہم 'flutter_html' استعمال کر کے اسے دکھائیں گے۔
      description: json['description'] ?? '',
      shortDescription: json['short_description'] ?? '',
      price: json['price']?.toString() ?? '0',
      regularPrice: json['regular_price']?.toString() ?? '',
      salePrice: json['sale_price']?.toString() ?? '',
      onSale: json['on_sale'] ?? false,
      imageUrl: mainImage,
      galleryImages: gallery,
      // WooCommerce ریٹنگ سٹرنگ میں دیتا ہے، اسے ڈبل میں کنورٹ کریں
      rating: double.tryParse(json['average_rating']?.toString() ?? '0.0') ?? 0.0,
      reviewCount: json['rating_count'] ?? 0,
      stockStatus: json['stock_status'] ?? 'instock',
      attributes: parsedAttributes,
    );
  }
}