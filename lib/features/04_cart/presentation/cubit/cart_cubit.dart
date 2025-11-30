import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/update_cart_item.dart';
import '../../domain/usecases/remove_cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCart getCart;
  final AddToCart addToCartUseCase;
  final UpdateCartItem updateCartItemUseCase;
  final RemoveCartItem removeCartItemUseCase;

  CartCubit({
    required this.getCart,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
  }) : super(CartInitial());

  /// 🚀 1. کارٹ لوڈ کریں
  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final items = await getCart();
      _calculateAndEmit(items);
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  /// ➕ 2. آئٹم شامل کریں
  Future<void> addToCart(int productId, int quantity) async {
    // ہم فی الحال پوری اسکرین کو لوڈنگ نہیں کر رہے، بس خاموشی سے ایڈ کریں گے
    // یا آپ چاہیں تو لوڈنگ دکھا سکتے ہیں
    try {
      final items = await addToCartUseCase(
        AddToCartParams(productId: productId, quantity: quantity),
      );
      _calculateAndEmit(items);
    } catch (e) {
      emit(CartError(message: "Failed to add to cart: $e"));
    }
  }

  /// 🔄 3. مقدار تبدیل کریں (Quantity Update)
  Future<void> updateQuantity(String key, int quantity) async {
    try {
      final items = await updateCartItemUseCase(
        UpdateCartParams(key: key, quantity: quantity),
      );
      _calculateAndEmit(items);
    } catch (e) {
      emit(CartError(message: "Failed to update cart"));
    }
  }

  /// 🗑️ 4. آئٹم ڈیلیٹ کریں
  Future<void> removeItem(String key) async {
    try {
      final items = await removeCartItemUseCase(key);
      _calculateAndEmit(items);
    } catch (e) {
      emit(CartError(message: "Failed to remove item"));
    }
  }

  /// 🧮 5. کیلکولیشن (Calculation Logic)
  void _calculateAndEmit(List<CartItem> items) {
    double subTotal = 0.0;

    for (var item in items) {
      // WooCommerce قیمت سٹرنگ میں دیتا ہے، اسے ڈبل میں کنورٹ کریں
      double price = double.tryParse(item.price) ?? 0.0;
      subTotal += price * item.quantity;
    }

    // شپنگ اور ٹیکس کا سادہ لاجک (بعد میں API سے بھی آ سکتا ہے)
    // [cite: 217] Design shows shipping $15.00
    double shippingFee = items.isEmpty ? 0.0 : 15.0;

    // [cite: 219] Design shows Tax logic (Let's say 10%)
    double tax = subTotal * 0.10;

    double totalAmount = subTotal + shippingFee + tax;

    emit(CartLoaded(
      items: items,
      subTotal: subTotal,
      shippingFee: shippingFee,
      tax: tax,
      totalAmount: totalAmount,
    ));
  }
}