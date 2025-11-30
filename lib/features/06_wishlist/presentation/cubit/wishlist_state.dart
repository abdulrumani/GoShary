import '../../../../features/03_product_and_category/domain/entities/product.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

// ✅ لسٹ لوڈ ہو گئی
class WishlistLoaded extends WishlistState {
  final List<Product> wishlist;

  WishlistLoaded({required this.wishlist});
}

// ❌ کوئی مسئلہ ہو گیا
class WishlistError extends WishlistState {
  final String message;

  WishlistError({required this.message});
}

// 🔄 جب کوئی آئٹم ایڈ یا ریموو ہو رہا ہو (Optional: لوڈنگ دکھانے کے لیے)
class WishlistToggling extends WishlistState {}