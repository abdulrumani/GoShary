import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetails {
  final ProductRepository repository;

  GetProductDetails({required this.repository});

  Future<Product> call(String id) async {
    return await repository.getProductDetails(id);
  }
}