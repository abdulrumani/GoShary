import '../../../../features/03_product_and_category/domain/entities/category.dart';
import '../../../../features/03_product_and_category/domain/entities/product.dart';

import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BannerEntity>> getBanners() async {
    try {
      final bannerModels = await remoteDataSource.getBanners();
      return bannerModels; // Models, Entities ہی ہوتے ہیں (Inheritance کی وجہ سے)
    } catch (e) {
      // اگر کوئی ایرر آئے تو خالی لسٹ بھیجیں تاکہ UI کریش نہ ہو
      return [];
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      return categoryModels;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Product>> getLatestProducts() async {
    try {
      final productModels = await remoteDataSource.getLatestProducts();
      return productModels;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Product>> getSaleProducts() async {
    try {
      final productModels = await remoteDataSource.getSaleProducts();
      return productModels;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final productModels = await remoteDataSource.getFeaturedProducts();
      return productModels;
    } catch (e) {
      return [];
    }
  }
}