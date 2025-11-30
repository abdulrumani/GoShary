import '../entities/category.dart';
import '../repositories/product_repository.dart';

class GetAllCategories {
  final ProductRepository repository;

  GetAllCategories({required this.repository});

  Future<List<Category>> call() async {
    return await repository.getAllCategories();
  }
}