import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart'; // HTML Description کے لیے
import 'package:go_router/go_router.dart';

// Core Imports
import 'package:goshary_app/core/config/app_colors.dart';
import 'package:goshary_app/core/config/app_typography.dart';
import 'package:goshary_app/core/navigation/route_names.dart';
import 'package:goshary_app/core/services/di_container.dart';
import 'package:goshary_app/core/utils/formatters.dart';
import 'package:goshary_app/core/widgets/custom_button.dart';
import 'package:goshary_app/core/widgets/loading_indicator.dart';
import 'package:goshary_app/features/04_cart/presentation/cubit/cart_cubit.dart';
import 'package:goshary_app/features/06_wishlist/presentation/cubit/wishlist_cubit.dart';

// Feature Imports
import '../../../domain/entities/product.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';
import '../widgets/product_variation_selector.dart'; // یہ فائل ہم نیچے بنائیں گے

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductDetailCubit>()..loadProductData(productId),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView();

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  // Images Slider State
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  // Selection State
  int _quantity = 1;
  // Attributes State (e.g., {'Size': 'M', 'Color': 'Red'})
  final Map<String, String> _selectedAttributes = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart(Product product) {
    // کارٹ میں ایڈ کرنے کا لاجک یہاں آئے گا (CartBloc Event)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart!"),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // باٹم بار (Sticky Bottom Bar) [cite: 185-186]
      bottomNavigationBar: _buildBottomBar(),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Scaffold(body: Center(child: LoadingIndicator()));
          } else if (state is ProductDetailError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 40, color: AppColors.error),
                    const SizedBox(height: 10),
                    Text(state.message),
                    TextButton(
                      onPressed: () => context.read<ProductDetailCubit>().loadProductData(""), // Retry logic needs ID fix
                      child: const Text("Retry"),
                    )
                  ],
                ),
              ),
            );
          } else if (state is ProductDetailLoaded) {
            final product = state.product;
            // اگر گیلری خالی ہے تو مین امیج استعمال کریں
            final images = product.galleryImages.isNotEmpty
                ? [product.imageUrl, ...product.galleryImages]
                : [product.imageUrl];

            return CustomScrollView(
              slivers: [
                // 1. Custom App Bar & Image Gallery
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite_border, color: Colors.black),
                      ),
                      onPressed: () {
                        // 👇 وش لسٹ لاجک
                        context.read<WishlistCubit>().toggleWishlist(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to Wishlist"), backgroundColor: AppColors.success),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() => _currentImageIndex = index);
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[100]),
                              errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                        // Image Indicators
                        if (images.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                    (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 8,
                                  width: _currentImageIndex == index ? 20 : 8,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == index
                                        ? AppColors.primary
                                        : Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 2. Product Details Body
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Rating [cite: 130-131]
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: AppTypography.textTheme.titleLarge,
                              ),
                            ),
                            // Rating Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: AppColors.warning),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${product.rating} (${product.reviewCount})",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Price Row [cite: 132]
                        Row(
                          children: [
                            Text(
                              AppFormatters.formatPrice(product.price),
                              style: AppTypography.textTheme.displaySmall?.copyWith(
                                color: AppColors.primary,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (product.regularPrice.isNotEmpty && product.onSale)
                              Text(
                                AppFormatters.formatPrice(product.regularPrice),
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Attributes (Size, Color) [cite: 133-141]
                        // یہ ویجیٹ ہم نیچے الگ فائل میں بنا رہے ہیں
                        if (product.attributes.isNotEmpty)
                          ProductVariationSelector(
                            attributes: product.attributes,
                            onSelectionChanged: (selection) {
                              setState(() {
                                _selectedAttributes.addAll(selection);
                              });
                            },
                          ),

                        const SizedBox(height: 24),

                        // Description [cite: 143-153]
                        Text("Description", style: AppTypography.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Html(
                          data: product.description.isNotEmpty
                              ? product.description
                              : "<p>No description available.</p>",
                          style: {
                            "body": Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              fontSize: FontSize(14),
                              color: AppColors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          },
                        ),

                        const SizedBox(height: 24),

                        // Reviews Summary [cite: 154-163]
                        _buildReviewsSection(state.reviews),

                        // Related Products (اگر وقت ہو تو یہاں HomeProductCarousel دوبارہ استعمال کریں)
                        const SizedBox(height: 100), // باٹم بار کے لیے جگہ
                      ],
                    ),
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

  // --- Reviews Section Helper ---
  Widget _buildReviewsSection(List<dynamic> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Reviews", style: AppTypography.textTheme.titleMedium),
            TextButton(
              onPressed: () {
                // See all reviews
              },
              child: const Text("See All"),
            )
          ],
        ),
        if (reviews.isEmpty)
          const Text("No reviews yet.", style: TextStyle(color: Colors.grey))
        else
          Column(
            children: reviews.take(2).map((review) {
              // یہاں آپ ایک ReviewCard بنا سکتے ہیں
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: review.avatarUrl.isNotEmpty
                      ? NetworkImage(review.avatarUrl)
                      : null,
                  child: review.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                title: Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  // HTML tags ہٹانے کے لیے سادہ ٹرک یا Html ویجیٹ استعمال کریں
                    review.reviewContent.replaceAll(RegExp(r'<[^>]*>'), ''),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    Text(review.rating.toString()),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // --- Bottom Bar Helper ---
  Widget _buildBottomBar() {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        final isLoaded = state is ProductDetailLoaded;
        final product = isLoaded ? state.product : null;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // QTY Counter
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                      ),
                      Text("$_quantity", style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () {
                          setState(() => _quantity++);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Add to Cart Button
                Expanded(
                  child: CustomButton(
                    text: "Add to Cart",
                    // 👇 یہاں تبدیلی کی گئی ہے
                    onPressed: isLoaded ? () {
                      // CartCubit کو کال کریں
                      context.read<CartCubit>().addToCart(product!.id, _quantity);

                      // کامیابی کا پیغام دکھائیں
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${product.name} added to cart"),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}