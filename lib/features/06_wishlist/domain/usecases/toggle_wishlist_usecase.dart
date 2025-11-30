import '../repositories/wishlist_repository.dart';

class ToggleWishlist {
  final WishlistRepository repository;

  ToggleWishlist({required this.repository});

  Future<bool> call(int productId) async {
    return await repository.toggleWishlist(productId);
  }
}