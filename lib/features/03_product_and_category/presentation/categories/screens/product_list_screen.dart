import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Bloc import for context.read
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/services/di_container.dart';
import '../../../../../core/config/app_colors.dart'; // Colors import
import '../../../../../core/widgets/product_card_widget.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../../core/navigation/route_names.dart';

// Feature Imports
import '../../../domain/entities/product.dart';
import '../../../data/datasources/product_remote_datasource.dart';
import '../../../../04_cart/presentation/cubit/cart_cubit.dart'; // For Add to Cart

class ProductListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // API سے پروڈکٹس لائیں
    _productsFuture = sl<ProductRemoteDataSource>().getRelatedProducts(widget.categoryId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.categoryName),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading products: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found in this category."));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCardWidget(
                // ✅ 1. نیا طریقہ: پورا پروڈکٹ پاس کریں
                product: product,

                // ❌ 2. پرانا طریقہ ختم کریں (productId لائن ہٹا دیں)

                title: product.name,
                imageUrl: product.imageUrl,
                price: double.tryParse(product.price) ?? 0.0,
                regularPrice: product.regularPrice.isNotEmpty
                    ? double.tryParse(product.regularPrice)
                    : null,
                rating: product.rating,
                reviewCount: product.reviewCount,
                onTap: () {
                  context.pushNamed(
                      RouteNames.productDetails,
                      pathParameters: {'id': product.id.toString()}
                  );
                },
                onAddToCart: () {
                  // Add to Cart
                  context.read<CartCubit>().addToCart(product.id, 1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product.name} added to cart"),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}