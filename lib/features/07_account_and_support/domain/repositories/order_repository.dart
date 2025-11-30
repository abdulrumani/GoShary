import '../../../05_checkout/domain/entities/order.dart';

abstract class OrderRepository {
  // یوزر کے آرڈرز لائیں
  Future<List<OrderEntity>> getMyOrders(int userId, {int page = 1});

  // آرڈر کی تفصیل لائیں
  Future<OrderEntity> getOrderDetails(int orderId);

  // آرڈر کینسل کریں
  Future<bool> cancelOrder(int orderId);
}