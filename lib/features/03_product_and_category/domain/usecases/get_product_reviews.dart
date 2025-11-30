import '../entities/review.dart';
import '../repositories/product_repository.dart';

class GetProductReviews {
  final ProductRepository repository;

  GetProductReviews({required this.repository});

  Future<List<Review>> call(String productId) async {
    return await repository.getProductReviews(productId);
  }
}