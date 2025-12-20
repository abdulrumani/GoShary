import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/app_colors.dart';
import '../utils/formatters.dart';
import 'loading_indicator.dart';

// 👇 Product Entity Import کریں
import '../../features/03_product_and_category/domain/entities/product.dart';
import '../../features/06_wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/06_wishlist/presentation/cubit/wishlist_state.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product; // ✅ تبدیلی: اب ہمیں پورا پروڈکٹ چاہیے
  // باقی چیزیں ویسے ہی رہنے دیں تاکہ UI نہ ٹوٹے
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
    required this.product, // ✅ یہاں شامل کریں
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
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: LoadingIndicator(size: 20)),
                      errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),
                if (discountPercent != null)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(8)),
                      child: Text('$discountPercent% OFF', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),

                // ❤️ Wishlist Button Logic
                Positioned(
                  top: 4, right: 4,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      bool isWishlisted = false;
                      if (state is WishlistLoaded) {
                        // چیک کریں کہ کیا پروڈکٹ لسٹ میں ہے؟
                        isWishlisted = state.wishlist.any((item) => item.id == product.id);
                      }

                      return IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? AppColors.error : AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          // ✅ اب یہاں ہم پورا پروڈکٹ بھیج رہے ہیں
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

            // Details Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.star, color: AppColors.warning, size: 14), const SizedBox(width: 4), Text('$rating ($reviewCount)', style: Theme.of(context).textTheme.bodySmall)]),
                  const SizedBox(height: 6),
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppFormatters.formatPrice(price), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                      InkWell(
                        onTap: onAddToCart,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18)),
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