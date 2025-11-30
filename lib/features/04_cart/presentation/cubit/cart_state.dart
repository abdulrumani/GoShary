import '../../domain/entities/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

// ✅ کارٹ لوڈڈ (آئٹمز اور کل قیمت کے ساتھ)
class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subTotal;
  final double shippingFee;
  final double tax;
  final double totalAmount;

  CartLoaded({
    required this.items,
    required this.subTotal,
    required this.shippingFee,
    required this.tax,
    required this.totalAmount,
  });
}

class CartError extends CartState {
  final String message;
  CartError({required this.message});
}