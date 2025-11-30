import '../entities/coupon.dart';
import '../entities/order.dart';

abstract class CheckoutRepository {
  Future<Coupon?> applyCoupon(String code);
  Future<OrderEntity> placeOrder(OrderEntity order);
}