import '../../../../05_checkout/domain/entities/order.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderEntity> orders;
  // ہم فلٹرنگ (Active/Completed) UI میں کریں گے، اس لیے صرف لسٹ کافی ہے
  OrderLoaded({required this.orders});
}

class OrderError extends OrderState {
  final String message;
  OrderError({required this.message});
}