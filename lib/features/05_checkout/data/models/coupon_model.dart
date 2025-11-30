// 👇 امپورٹ کا راستہ ٹھیک کریں (یا اپنی ایپ کے نام کے ساتھ package import استعمال کریں)
import '../../domain/entities/coupon.dart';

class CouponModel extends Coupon { // 👈 یقینی بنائیں کہ 'extends Coupon' لکھا ہو
  CouponModel({
    required super.id,
    required super.code,
    required super.amount,
    required super.discountType,
    required super.description,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      discountType: json['discount_type'] ?? 'fixed_cart',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'amount': amount,
      'discount_type': discountType,
      'description': description,
    };
  }
}