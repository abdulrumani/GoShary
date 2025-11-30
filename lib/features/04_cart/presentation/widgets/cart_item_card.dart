import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Product Image [cite: 190]
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (c, u, e) => const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 2. Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.textTheme.titleMedium?.copyWith(fontSize: 16),
                      ),
                    ),
                    // Delete Icon
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(Icons.delete_outline, color: AppColors.textSecondary, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Attributes (Size, Color) [cite: 192-193]
                if (item.variation.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: item.variation.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${entry.key}: ${entry.value}",
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 12),

                // Price & Quantity [cite: 194-195]
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppFormatters.formatPrice(item.price),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),

                    // Qty Counter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: onDecrement,
                            child: const Icon(Icons.remove, size: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "${item.quantity}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: onIncrement,
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}