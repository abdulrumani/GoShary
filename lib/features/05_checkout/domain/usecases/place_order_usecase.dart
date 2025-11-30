import '../entities/order.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrder {
  final CheckoutRepository repository;

  PlaceOrder({required this.repository});

  Future<OrderEntity> call(OrderEntity order) async {
    return await repository.placeOrder(order);
  }
}