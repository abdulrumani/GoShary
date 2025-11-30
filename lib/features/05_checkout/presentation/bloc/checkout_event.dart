import '../../domain/entities/order.dart';

abstract class CheckoutEvent {}

// 🎟️ کوپن کوڈ اپلائی کرنا
class ApplyCouponEvent extends CheckoutEvent {
  final String code;
  ApplyCouponEvent({required this.code});
}

// 📦 آرڈر پلیس کرنا (Place Order)
class PlaceOrderEvent extends CheckoutEvent {
  final OrderEntity order;
  PlaceOrderEvent({required this.order});
}

// 💳 پیمنٹ میتھڈ منتخب کرنا (Optional: اگر آپ اسے Bloc میں ٹریک کرنا چاہیں)
class SelectPaymentMethodEvent extends CheckoutEvent {
  final String method;
  SelectPaymentMethodEvent({required this.method});
}