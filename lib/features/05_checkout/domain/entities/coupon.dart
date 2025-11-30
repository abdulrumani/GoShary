class Coupon {
  final int id;
  final String code;
  final String amount; // ڈسکاؤنٹ کی رقم
  final String discountType; // 'percent', 'fixed_cart', etc.
  final String description;

  Coupon({
    required this.id,
    required this.code,
    required this.amount,
    required this.discountType,
    required this.description,
  });
}