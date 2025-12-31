import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/app_colors.dart';
import '../utils/formatters.dart';
import 'loading_indicator.dart';

// Product Entity Import
import '../../features/03_product_and_category/domain/entities/product.dart';
import '../../features/06_wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/06_wishlist/presentation/cubit/wishlist_state.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
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
    required this.product,
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
          mainAxisSize: MainAxisSize.min, // ✅ ایرر فکس: Content کو جتنا ہو سکے سکڑنے دیں
          children: [
            // --- 1. Image Section (Fixed Height) ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 125, // تھوڑی سی ہائٹ کم کی تاکہ نیچے جگہ بچے
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: LoadingIndicator(size: 20)),
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
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                // Wishlist Button
                Positioned(
                  top: 0, right: 0,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      bool isWishlisted = false;
                      if (state is WishlistLoaded) {
                        isWishlisted = state.wishlist.any((item) => item.id == product.id);
                      }

                      return IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? AppColors.error : AppColors.textSecondary,
                          size: 18,
                        ),
                        onPressed: () {
                          context.read<WishlistCubit>().toggleWishlist(product);
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

            // --- 2. Details Section (Flexible) ---
            Flexible( // Expanded کی جگہ Flexible استعمال کریں
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // اہم
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating Row
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.warning, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$rating ($reviewCount)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Price & Cart Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end, // نیچے سے الائن کریں
                      children: [
                        // Price Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (regularPrice != null && regularPrice! > price)
                                Text(
                                  AppFormatters.formatPrice(regularPrice),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                AppFormatters.formatPrice(price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Add to Cart Button
                        InkWell(
                          onTap: onAddToCart,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
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