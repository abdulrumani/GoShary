import '../../../05_checkout/domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderEntity>> getMyOrders(int userId, {int page = 1}) async {
    try {
      return await remoteDataSource.getMyOrders(userId, page: page);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<OrderEntity> getOrderDetails(int orderId) async {
    try {
      return await remoteDataSource.getOrderDetails(orderId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> cancelOrder(int orderId) async {
    try {
      return await remoteDataSource.cancelOrder(orderId);
    } catch (e) {
      return false;
    }
  }
}