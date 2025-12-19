import '../../../../features/03_product_and_category/domain/entities/product.dart';
import '../../../../features/03_product_and_category/data/models/product_model.dart'; // Model Import کریں
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getWishlist() async {
    try {
      return await remoteDataSource.getWishlist();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> toggleWishlist(Product product) async {
    try {
      // 👇 اہم: Entity کو Model میں تبدیل کرنا ضروری ہے تاکہ ڈیٹا سورس اسے قبول کرے
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        shortDescription: product.shortDescription,
        price: product.price,
        regularPrice: product.regularPrice,
        salePrice: product.salePrice,
        onSale: product.onSale,
        imageUrl: product.imageUrl,
        galleryImages: product.galleryImages,
        rating: product.rating,
        reviewCount: product.reviewCount,
        stockStatus: product.stockStatus,
        attributes: product.attributes,
      );

      return await remoteDataSource.toggleWishlist(productModel);
    } catch (e) {
      return false;
    }
  }
}