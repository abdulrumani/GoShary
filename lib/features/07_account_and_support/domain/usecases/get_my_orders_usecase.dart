import '../../../05_checkout/domain/entities/order.dart';
import '../repositories/order_repository.dart';

class GetMyOrders {
  final OrderRepository repository;

  GetMyOrders({required this.repository});

  Future<List<OrderEntity>> call(int userId, {int page = 1}) async {
    return await repository.getMyOrders(userId, page: page);
  }
}