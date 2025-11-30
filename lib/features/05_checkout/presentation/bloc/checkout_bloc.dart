import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/apply_coupon_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ApplyCoupon applyCoupon;
  final PlaceOrder placeOrder;

  CheckoutBloc({
    required this.applyCoupon,
    required this.placeOrder,
  }) : super(CheckoutInitial()) {

    // 1. Coupon Logic
    on<ApplyCouponEvent>((event, emit) async {
      emit(CheckoutLoading());
      try {
        final coupon = await applyCoupon(event.code);
        if (coupon != null) {
          emit(CouponApplied(coupon: coupon));
        } else {
          emit(CouponError(message: "Invalid Coupon Code"));
        }
      } catch (e) {
        emit(CouponError(message: "Failed to apply coupon: $e"));
      }
    });

    // 2. Place Order Logic
    on<PlaceOrderEvent>((event, emit) async {
      emit(CheckoutLoading());
      try {
        final order = await placeOrder(event.order);
        emit(OrderSuccess(order: order));
      } catch (e) {
        emit(OrderFailure(message: "Failed to place order. Please try again."));
      }
    });
  }
}