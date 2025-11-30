import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetRelatedProducts {
  final ProductRepository repository;

  GetRelatedProducts({required this.repository});

  Future<List<Product>> call(String categoryId) async {
    return await repository.getRelatedProducts(categoryId);
  }
}