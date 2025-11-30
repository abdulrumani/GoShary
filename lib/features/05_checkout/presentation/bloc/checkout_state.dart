import '../../domain/entities/coupon.dart';
import '../../domain/entities/order.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

// --- Loading States ---
class CheckoutLoading extends CheckoutState {} // General Loading

// --- Coupon States ---
class CouponApplied extends CheckoutState {
  final Coupon coupon;
  CouponApplied({required this.coupon});
}

class CouponError extends CheckoutState {
  final String message;
  CouponError({required this.message});
}

// --- Order States ---
class OrderSuccess extends CheckoutState {
  final OrderEntity order;
  OrderSuccess({required this.order});
}

class OrderFailure extends CheckoutState {
  final String message;
  OrderFailure({required this.message});
}