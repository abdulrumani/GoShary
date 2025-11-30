import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Bloc شامل کیا

import '../config/app_colors.dart';
import '../utils/formatters.dart';
import 'loading_indicator.dart';

// Wishlist Cubit Import (تاکہ ہم اسٹیٹ چیک کر سکیں)
import '../../features/06_wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/06_wishlist/presentation/cubit/wishlist_state.dart';

class ProductCardWidget extends StatelessWidget {
  final int productId; // ✅ نیا: ID ضروری ہے تاکہ ہم وش لسٹ چیک کر سکیں
  final String title;
  final String imageUrl;
  final double price;
  final double? regularPrice;
  final double rating;
  final int reviewCount;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ProductCardWidget({
    super.key,
    required this.productId, // ✅ یہاں شامل کیا
    required this.title,
    required this.imageUrl,
    required this.price,
    this.regularPrice,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // سیل کا حساب
    int? discountPercent;
    if (regularPrice != null && regularPrice! > price) {
      discountPercent = ((regularPrice! - price) / regularPrice! * 100).round();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
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
          children: [
            // --- 1. Image & Badges Section ---
            Stack(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: LoadingIndicator(size: 20),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Discount Badge
                if (discountPercent != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Wishlist Button (BlocBuilder کے ساتھ)
                Positioned(
                  top: 4,
                  right: 4,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      bool isWishlisted = false;

                      // چیک کریں کہ کیا یہ پروڈکٹ لسٹ میں موجود ہے؟
                      if (state is WishlistLoaded) {
                        isWishlisted = state.wishlist.any((item) => item.id == productId);
                      }

                      return IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? AppColors.error : AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          // Wishlist Toggle Action
                          context.read<WishlistCubit>().toggleWishlist(productId);

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isWishlisted ? "Removed from Wishlist" : "Added to Wishlist"),
                              duration: const Duration(seconds: 1),
                              backgroundColor: isWishlisted ? Colors.grey : AppColors.success,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // --- 2. Details Section ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.warning, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '$rating ($reviewCount)',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (regularPrice != null && regularPrice! > price)
                            Text(
                              AppFormatters.formatPrice(regularPrice),
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          Text(
                            AppFormatters.formatPrice(price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      // Add to Cart Button
                      InkWell(
                        onTap: onAddToCart,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}