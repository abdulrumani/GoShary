import '../entities/coupon.dart';
import '../repositories/checkout_repository.dart';

class ApplyCoupon {
  final CheckoutRepository repository;

  ApplyCoupon({required this.repository});

  Future<Coupon?> call(String code) async {
    return await repository.applyCoupon(code);
  }
}