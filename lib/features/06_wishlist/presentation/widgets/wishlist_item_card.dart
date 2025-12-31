import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../features/03_product_and_category/domain/entities/product.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // ڈسکاؤنٹ کا حساب
    int? discountPercent;
    double priceVal = double.tryParse(product.price) ?? 0.0;
    double regularVal = double.tryParse(product.regularPrice) ?? 0.0;

    if (regularVal > priceVal) {
      discountPercent = ((regularVal - priceVal) / regularVal * 100).round();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ✅ ایرر فکس: Content کو سکڑنے دیں
          children: [
            // --- 1. Image Section (Flexible) ---
            Expanded( // ✅ Image کو Expanded بنائیں تاکہ باقی جگہ لے سکے
              flex: 5, // تصویر کو زیادہ حصہ دیں
              child: Stack(
                fit: StackFit.expand, // تصویر کو پورا پھیلائیں
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (c, u, e) => Container(
                        color: AppColors.inputFill,
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),

                  // Discount Badge
                  if (discountPercent != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "-$discountPercent%",
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  // Remove Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: AppColors.error, size: 20),
                      onPressed: onRemove,
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. Details Section (Flexible) ---
            Expanded( // ✅ Details کو بھی Expanded بنائیں تاکہ باقی بچی جگہ لے سکے
              flex: 4, // ڈیٹیلز کو تھوڑا کم حصہ دیں
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // جگہ برابر تقسیم کریں
                  children: [
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${product.rating} (${product.reviewCount})",
                            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Title
                    Text(
                      product.name,
                      maxLines: 2, // 2 لائنوں تک جانے دیں
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, height: 1.2),
                    ),

                    // Price
                    Row(
                      children: [
                        Text(
                          AppFormatters.formatPrice(product.price),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                        ),
                        if (regularVal > priceVal) ...[
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              AppFormatters.formatPrice(product.regularPrice),
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 30, // بٹن کی اونچائی فکس کریں
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("Add to Cart", style: TextStyle(fontSize: 11, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}