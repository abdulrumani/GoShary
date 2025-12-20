import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../../../04_cart/presentation/cubit/cart_cubit.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';
import '../widgets/wishlist_item_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Wishlist"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is WishlistError) {
            return Center(child: Text(state.message));
          } else if (state is WishlistLoaded) {
            final wishlist = state.wishlist;

            if (wishlist.isEmpty) {
              return _buildEmptyWishlist(context);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Count Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    "${wishlist.length} items",
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Product Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: wishlist.length,
                    itemBuilder: (context, index) {
                      final product = wishlist[index];
                      return WishlistItemCard(
                        product: product,
                        onTap: () {
                          context.pushNamed(
                            RouteNames.productDetails,
                            pathParameters: {'id': product.id.toString()},
                          );
                        },
                        onRemove: () {
                          // ❌ غلط: context.read<WishlistCubit>().toggleWishlist(product.id);
                          // ✅ صحیح: اب ہمیں پورا پروڈکٹ بھیجنا ہے
                          context.read<WishlistCubit>().toggleWishlist(product);
                        },
                        onAddToCart: () {
                          // Cart میں ID ہی استعمال ہوتی ہے، یہ ٹھیک ہے
                          context.read<CartCubit>().addToCart(product.id, 1);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} added to cart"),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      );
                    },
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

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 20),
          Text("Your Wishlist is Empty", style: AppTypography.textTheme.titleLarge),
          const SizedBox(height: 10),
          const Text("Save items you love to buy later.", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.goNamed(RouteNames.home),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: const Text("Explore Products", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}