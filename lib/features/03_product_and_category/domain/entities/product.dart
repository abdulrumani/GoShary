class Product {
  final int id;
  final String name;
  final String description;
  final String shortDescription;
  final String price;
  final String regularPrice;
  final String salePrice;
  final bool onSale;
  final String imageUrl; // Main image
  final List<String> galleryImages; // Other images
  final double rating;
  final int reviewCount;
  final String stockStatus; // 'instock', 'outofstock'
  final List<ProductAttribute> attributes; // Color, Size etc.

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    required this.imageUrl,
    required this.galleryImages,
    required this.rating,
    required this.reviewCount,
    required this.stockStatus,
    required this.attributes,
  });
}

class ProductAttribute {
  final String name; // e.g., "Size"
  final List<String> options; // e.g., ["S", "M", "L"]

  ProductAttribute({required this.name, required this.options});
}