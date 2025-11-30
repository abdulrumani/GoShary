import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/navigation/route_names.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/custom_button.dart';

// Feature Imports
import '../../../../05_checkout/domain/entities/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // اسٹیٹس کا رنگ
    Color statusColor = AppColors.textSecondary;
    if (order.status == 'completed') statusColor = AppColors.success;
    if (order.status == 'cancelled') statusColor = AppColors.error;
    if (order.status == 'processing') statusColor = AppColors.warning;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (ID & Status)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order #${order.id}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        AppFormatters.formatDateTime(DateTime.parse(order.dateCreated)),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Text("Status: ", style: TextStyle(color: AppColors.textSecondary)),
                      Text(
                        order.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Items List
            const Text("Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.lineItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _buildOrderItem(order.lineItems[index]);
              },
            ),

            const SizedBox(height: 24),

            // 3. Shipping Address
            const Text("Shipping Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${order.shipping.firstName} ${order.shipping.lastName}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(order.shipping.address1, style: const TextStyle(color: AppColors.textSecondary)),
                  Text("${order.shipping.city}, ${order.shipping.state} ${order.shipping.postcode}",
                      style: const TextStyle(color: AppColors.textSecondary)),
                  Text(order.shipping.country, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(order.shipping.phone, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Payment Info
            const Text("Payment Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payment, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Payment Method", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        order.paymentMethodTitle.isEmpty ? order.paymentMethod : order.paymentMethodTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Total Amount", order.total, isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 6. Action Buttons
            if (order.status == 'processing' || order.status == 'pending') ...[
              CustomButton(
                text: "Track Order",
                onPressed: () {
                  // Tracking Screen پر جائیں اور آرڈر ID پاس کریں
                  context.pushNamed(
                    RouteNames.orderTracking,
                    extra: order.id,
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Cancel Order Logic (Cubit Event)
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Cancel Order"),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderLineItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Image Placeholder (چونکہ Order API میں اکثر امیج نہیں ہوتی، ہم آئیکن دکھا رہے ہیں)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text("Qty: ${item.quantity}", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(
            AppFormatters.formatPrice(item.total), // Total is string in our model
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          AppFormatters.formatPrice(amount),
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? AppColors.primary : Colors.black,
          ),
        ),
      ],
    );
  }
}