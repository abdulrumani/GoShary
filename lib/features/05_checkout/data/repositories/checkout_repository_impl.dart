import '../../domain/entities/coupon.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';
import '../models/order_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  // یہاں 'async' لکھنا ضروری ہے 👇
  Future<Coupon?> applyCoupon(String code) async {
    try {
      final model = await remoteDataSource.applyCoupon(code);
      return model; // اب یہ درست کام کرے گا کیونکہ async اسے Future میں لپیٹ دے گا
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderEntity> placeOrder(OrderEntity order) async {
    try {
      // Entity کو Model میں کاسٹ کریں (کیونکہ ہمیں toJson چاہیے)
      // یا نیا ماڈل بنائیں
      final orderModel = OrderModel(
        id: order.id,
        status: order.status,
        total: order.total,
        dateCreated: order.dateCreated,
        paymentMethod: order.paymentMethod,
        paymentMethodTitle: order.paymentMethodTitle,
        billing: order.billing,
        shipping: order.shipping,
        lineItems: order.lineItems,
      );

      return await remoteDataSource.placeOrder(orderModel);
    } catch (e) {
      rethrow;
    }
  }
}