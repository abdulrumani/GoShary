import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CartItem>> getCart() async {
    try {
      final List<CartItemModel> models = await remoteDataSource.getCart();
      // Model کو Entity کی لسٹ کے طور پر واپس کریں
      return _mapModelsToEntities(models);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<CartItem>> addToCart({required int productId, required int quantity}) async {
    try {
      final models = await remoteDataSource.addToCart(productId: productId, quantity: quantity);
      return _mapModelsToEntities(models);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> updateCartItem({required String key, required int quantity}) async {
    try {
      final models = await remoteDataSource.updateCartItem(key: key, quantity: quantity);
      return _mapModelsToEntities(models);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> removeCartItem({required String key}) async {
    try {
      final models = await remoteDataSource.removeCartItem(key: key);
      return _mapModelsToEntities(models);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    await remoteDataSource.clearCart();
  }

  // Helper to convert List<Model> to List<Entity>
  List<CartItem> _mapModelsToEntities(List<CartItemModel> models) {
    return models.map((model) => CartItem(
      key: model.key,
      productId: model.productId,
      name: model.name,
      price: model.price,
      quantity: model.quantity,
      imageUrl: model.imageUrl,
      variation: model.variation,
      lineSubtotal: model.lineSubtotal,
    )).toList();
  }
}