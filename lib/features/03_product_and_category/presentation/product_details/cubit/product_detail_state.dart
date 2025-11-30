import '../../../domain/entities/product.dart';
import '../../../domain/entities/review.dart';

abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

// ✅ جب سارا ڈیٹا (پروڈکٹ، ریویوز، اور متعلقہ پروڈکٹس) لوڈ ہو جائے
class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  final List<Review> reviews;
  final List<Product> relatedProducts;

  ProductDetailLoaded({
    required this.product,
    required this.reviews,
    required this.relatedProducts,
  });
}

class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError({required this.message});
}