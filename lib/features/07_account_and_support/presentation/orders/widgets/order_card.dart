import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../05_checkout/domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // اسٹیٹس کا رنگ اور ٹیکسٹ سیٹ کرنا
    Color statusColor;
    String statusText = order.status.toUpperCase();

    switch (order.status) {
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'processing':
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'cancelled':
      case 'failed':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  AppFormatters.formatDateTime(DateTime.parse(order.dateCreated)),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Items Count & Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${order.lineItems.length} Items",
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  AppFormatters.formatPrice(order.total),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}