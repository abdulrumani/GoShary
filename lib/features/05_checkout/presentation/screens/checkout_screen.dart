import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/services/di_container.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../../domain/entities/order.dart';
import '../../../04_cart/presentation/cubit/cart_cubit.dart';
import '../../../04_cart/presentation/cubit/cart_state.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';
import '../widgets/payment_method_selector.dart'; // نیچے بنایا گیا ویجیٹ

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CheckoutBloc>(),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  // Payment Selection State
  String _selectedPaymentMethod = 'cod'; // Default: Cash on Delivery
  String _selectedPaymentTitle = 'Cash on Delivery';

  // Address State (فی الحال ہم اسے Mock کر رہے ہیں، بعد میں Address Feature سے جوڑیں گے)
  bool _hasAddress = true;
  final OrderAddress _mockAddress = OrderAddress(
    firstName: "Sarah",
    lastName: "Anderson",
    address1: "123 Fashion Street",
    city: "Jeddah",
    state: "Makkah",
    postcode: "21442",
    country: "SA",
    email: "sarah@example.com",
    phone: "+966500000000",
  );

  void _onPlaceOrder(BuildContext context, double total) {
    if (!_hasAddress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add a shipping address")),
      );
      return;
    }

    // 1. Cart Items حاصل کریں
    final cartState = context.read<CartCubit>().state;
    if (cartState is! CartLoaded) return;

    // 2. Line Items بنائیں
    final lineItems = cartState.items.map((item) {
      return OrderLineItem(
        productId: item.productId,
        name: item.name,
        quantity: item.quantity,
        total: item.lineSubtotal,
      );
    }).toList();

    // 3. Order Object بنائیں
    final order = OrderEntity(
      id: 0, // New Order
      status: 'processing',
      total: total.toString(),
      dateCreated: DateTime.now().toIso8601String(),
      paymentMethod: _selectedPaymentMethod,
      paymentMethodTitle: _selectedPaymentTitle,
      billing: _mockAddress,
      shipping: _mockAddress,
      lineItems: lineItems,
    );

    // 4. Bloc Event بھیجیں
    context.read<CheckoutBloc>().add(PlaceOrderEvent(order: order));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 60),
            const SizedBox(height: 20),
            Text("Order Placed!", style: AppTypography.textTheme.titleLarge),
            const SizedBox(height: 10),
            const Text("Your order has been placed successfully. You can track it in 'My Orders'.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            CustomButton(
              text: "Continue Shopping",
              onPressed: () {
                // Cart صاف کریں
                context.read<CartCubit>().loadCart();
                // Dialog بند کریں
                Navigator.pop(ctx);
                // Home پر جائیں
                context.goNamed(RouteNames.home);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            // Cart صاف کریں (اگر API خود نہیں کرتی)
            context.read<CartCubit>().loadCart(); // Reload empty cart
            _showSuccessDialog();
          } else if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState is! CartLoaded || cartState.items.isEmpty) {
              return const Center(child: Text("Your cart is empty"));
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Shipping Address Section
                      Text("Shipping Address", style: AppTypography.textTheme.titleMedium),
                      const SizedBox(height: 10),
                      _buildAddressCard(context),

                      const SizedBox(height: 24),

                      // 2. Payment Method Section
                      Text("Payment Method", style: AppTypography.textTheme.titleMedium),
                      const SizedBox(height: 10),
                      PaymentMethodSelector(
                        selectedMethod: _selectedPaymentMethod,
                        onMethodSelected: (method, title) async {
                          // اسکرین کھولیں اور رزلٹ کا انتظار کریں
                          final result = await context.pushNamed(
                            RouteNames.paymentMethods,
                            extra: _selectedPaymentMethod, // موجودہ سلیکشن پاس کریں
                          );

                          // اگر یوزر نے نیا میتھڈ سلیکٹ کیا ہے
                          if (result != null && result is Map) {
                            setState(() {
                              _selectedPaymentMethod = result['method'];
                              _selectedPaymentTitle = result['title'];
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // 3. Order Summary (Brief)
                      Text("Order Summary", style: AppTypography.textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow("Items (${cartState.items.length})", cartState.subTotal),
                            _buildSummaryRow("Shipping", cartState.shippingFee),
                            _buildSummaryRow("Tax", cartState.tax),
                            const Divider(),
                            _buildSummaryRow("Total", cartState.totalAmount, isBold: true, fontSize: 18),
                          ],
                        ),
                      ),

                      // Bottom Padding for Button
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // 4. Bottom Place Order Button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: BlocBuilder<CheckoutBloc, CheckoutState>(
                      builder: (context, checkoutState) {
                        return CustomButton(
                          text: "Place Order - ${AppFormatters.formatPrice(cartState.totalAmount)}",
                          isLoading: checkoutState is CheckoutLoading,
                          onPressed: () => _onPlaceOrder(context, cartState.totalAmount),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- Address Card Helper ---
  Widget _buildAddressCard(BuildContext context) {
    if (!_hasAddress) {
      return GestureDetector(
        onTap: () {
          // Navigate to Add Address Screen
          context.pushNamed(RouteNames.addAddress);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.primary),
                SizedBox(width: 8),
                Text("Add New Address", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_mockAddress.firstName} ${_mockAddress.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_mockAddress.address1}, ${_mockAddress.city}",
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                Text(
                  _mockAddress.phone,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Edit Address
            },
            child: const Text("Edit"),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            AppFormatters.formatPrice(amount),
            style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}