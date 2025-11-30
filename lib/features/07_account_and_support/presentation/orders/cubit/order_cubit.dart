import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../domain/usecases/get_my_orders_usecase.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetMyOrders getMyOrders;
  final StorageService storageService;

  OrderCubit({
    required this.getMyOrders,
    required this.storageService,
  }) : super(OrderInitial());

  Future<void> loadOrders() async {
    emit(OrderLoading());
    try {
      // 1. یوزر ID حاصل کریں
      final userIdStr = storageService.getUserId();

      if (userIdStr == null) {
        emit(OrderError(message: "User not found. Please login again."));
        return;
      }

      final int userId = int.parse(userIdStr);

      // 2. UseCase کال کریں
      final orders = await getMyOrders(userId);

      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}