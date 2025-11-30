import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CartCubit پہلے سے global (app.dart میں) ہے، اس لیے دوبارہ پرووائیڈ کرنے کی ضرورت نہیں
    // لیکن اگر ہم چاہیں کہ ہر بار اسکرین کھلنے پر ڈیٹا ریفریش ہو، تو ہم loadCart کال کر سکتے ہیں
    // context.read<CartCubit>().loadCart();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Wishlist Icon (Optional)
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () => context.pushNamed(RouteNames.wishlist),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: AppColors.error),
                  const SizedBox(height: 10),
                  Text(state.message),
                  TextButton(
                    onPressed: () => context.read<CartCubit>().loadCart(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyCart(context);
            }

            return Column(
              children: [
                // 1. Cart Items List [cite: 189-207]
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return CartItemCard(
                        item: item,
                        onIncrement: () {
                          context.read<CartCubit>().updateQuantity(item.key, item.quantity + 1);
                        },
                        onDecrement: () {
                          if (item.quantity > 1) {
                            context.read<CartCubit>().updateQuantity(item.key, item.quantity - 1);
                          }
                        },
                        onRemove: () {
                          context.read<CartCubit>().removeItem(item.key);
                        },
                      );
                    },
                  ),
                ),

                // 2. Coupon & Order Summary [cite: 212-221]
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Coupon Input
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: "Enter coupon code",
                              prefixIcon: Icons.local_offer_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CustomButton(
                            text: "Apply",
                            width: 80,
                            height: 50, // Match TextField height roughly
                            onPressed: () {
                              // Apply Coupon Logic
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Summary Rows
                      _buildSummaryRow("Subtotal", state.subTotal),
                      const SizedBox(height: 10),
                      _buildSummaryRow("Shipping", state.shippingFee),
                      const SizedBox(height: 10),
                      _buildSummaryRow("Tax", state.tax),
                      const Divider(height: 30),
                      _buildSummaryRow("Total", state.totalAmount, isTotal: true),

                      const SizedBox(height: 24),

                      // Checkout Button [cite: 222]
                      CustomButton(
                        text: "Proceed to Checkout",
                        onPressed: () {
                          context.pushNamed(RouteNames.checkout);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 20),
          Text("Your Cart is Empty", style: AppTypography.textTheme.titleLarge),
          const SizedBox(height: 10),
          const Text("Looks like you haven't added anything yet.", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 30),
          CustomButton(
            text: "Start Shopping",
            width: 200,
            onPressed: () => context.goNamed(RouteNames.home),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              : const TextStyle(color: AppColors.textSecondary),
        ),
        Text(
          AppFormatters.formatPrice(amount),
          style: isTotal
              ? AppTypography.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              : const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}