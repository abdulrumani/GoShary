import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/widgets/product_card_widget.dart';
import '../../../../features/03_product_and_category/domain/entities/product.dart';

class HomeProductCarousel extends StatelessWidget {
  final String title;
  final List<Product> products;
  final bool isSale;
  final VoidCallback? onSeeAllTap;

  const HomeProductCarousel({
    super.key,
    required this.title,
    required this.products,
    this.isSale = false,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: AppTypography.textTheme.titleMedium),
                  if (isSale) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.local_fire_department, color: AppColors.error, size: 20),
                  ]
                ],
              ),
              GestureDetector(
                onTap: onSeeAllTap,
                child: Text("View All", style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCardWidget(
                // ✅ صرف 'product' بھیجیں، 'productId' کی ضرورت نہیں
                product: product,

                // ❌ یہ لائن مٹا دی گئی ہے: productId: product.id,

                title: product.name,
                imageUrl: product.imageUrl,
                price: double.tryParse(product.price) ?? 0.0,
                regularPrice: product.regularPrice.isNotEmpty ? double.tryParse(product.regularPrice) : null,
                rating: product.rating,
                reviewCount: product.reviewCount,
                onTap: () {
                  context.pushNamed(
                    RouteNames.productDetails,
                    pathParameters: {'id': product.id.toString()},
                  );
                },
                onAddToCart: () {
                  // Add to Cart Logic
                },
              );
            },
          ),
        ),
      ],
    );
  }
}