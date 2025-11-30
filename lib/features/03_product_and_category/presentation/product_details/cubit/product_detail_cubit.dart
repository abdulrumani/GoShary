import 'package:flutter_bloc/flutter_bloc.dart';

// Package Imports استعمال کر رہے ہیں تاکہ Path Conflict نہ آئے
import '../../../domain/entities/product.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/usecases/get_product_details.dart';
import '../../../domain/usecases/get_product_reviews.dart';
import '../../../domain/usecases/get_related_products.dart';

import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductDetails getProductDetails;
  final GetProductReviews getProductReviews;
  final GetRelatedProducts getRelatedProducts;

  ProductDetailCubit({
    required this.getProductDetails,
    required this.getProductReviews,
    required this.getRelatedProducts,
  }) : super(ProductDetailInitial());

  /// 🚀 پروڈکٹ کا سارا ڈیٹا لوڈ کریں
  Future<void> loadProductData(String productId) async {
    emit(ProductDetailLoading());

    try {
      // 1. سب سے پہلے پروڈکٹ کی تفصیل لائیں
      final product = await getProductDetails(productId);

      // 2. اب متوازی طور پر (Parallel) ریویوز اور متعلقہ پروڈکٹس لائیں
      final results = await Future.wait([
        getProductReviews(productId),
        getRelatedProducts('0'), // فی الحال ڈیفالٹ کیٹیگری بھیج رہے ہیں
      ]);

      // 3. 👇 Casting Fix: یہاں ہم ڈیٹا کو زبردستی صحیح ٹائپ بتا رہے ہیں
      // 'results[0]' کو List<Review> بنا رہے ہیں
      final reviewsList = (results[0] as List).cast<Review>().toList();

      // 'results[1]' کو List<Product> بنا رہے ہیں
      final relatedList = (results[1] as List).cast<Product>().toList();

      emit(ProductDetailLoaded(
        product: product,
        reviews: reviewsList,
        relatedProducts: relatedList,
      ));

    } catch (e) {
      emit(ProductDetailError(message: e.toString()));
    }
  }
}
