import 'package:flutter_bloc/flutter_bloc.dart';
// 👇 یہ امپورٹ شامل کرنا نہ بھولیں (Product Entity کے لیے)
import '../../../../features/03_product_and_category/domain/entities/product.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/toggle_wishlist_usecase.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlist getWishlistUseCase;
  final ToggleWishlist toggleWishlistUseCase;

  WishlistCubit({
    required this.getWishlistUseCase,
    required this.toggleWishlistUseCase,
  }) : super(WishlistInitial());

  /// ❤️ 1. وش لسٹ لوڈ کریں
  Future<void> loadWishlist() async {
    emit(WishlistLoading());
    try {
      final items = await getWishlistUseCase();
      emit(WishlistLoaded(wishlist: items));
    } catch (e) {
      emit(WishlistError(message: "Failed to load wishlist"));
    }
  }

  /// 🔄 2. آئٹم ایڈ یا ریموو کریں
  // ⚠️ تبدیلی: یہاں 'int productId' کو ہٹا کر 'Product product' لکھیں
  Future<void> toggleWishlist(Product product) async {
    try {
      // موجودہ اسٹیٹ کو محفوظ رکھنے کی ضرورت نہیں کیونکہ UI فوراً اپڈیٹ ہو جائے گا

      // ٹوگل ایکشن پرفارم کریں (اب یہ پورا پروڈکٹ لے گا)
      await toggleWishlistUseCase(product);

      // لسٹ کو ریفریش کریں تاکہ نئی حالت نظر آئے
      await loadWishlist();

    } catch (e) {
      emit(WishlistError(message: "Failed to update wishlist"));
    }
  }
}