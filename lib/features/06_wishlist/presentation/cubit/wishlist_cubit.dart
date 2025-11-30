import 'package:flutter_bloc/flutter_bloc.dart';
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
  Future<void> toggleWishlist(int productId) async {
    try {
      // اگر ہم لوڈڈ اسٹیٹ میں ہیں تو موجودہ لسٹ کو محفوظ رکھیں
      // تاکہ لوڈنگ کے دوران اسکرین خالی نہ ہو جائے
      final currentState = state;

      // ٹوگل ایکشن پرفارم کریں
      await toggleWishlistUseCase(productId);

      // لسٹ کو ریفریش کریں تاکہ نئی حالت نظر آئے
      await loadWishlist();

    } catch (e) {
      emit(WishlistError(message: "Failed to update wishlist"));
    }
  }
}