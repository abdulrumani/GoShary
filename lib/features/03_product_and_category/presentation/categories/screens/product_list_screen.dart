import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/services/di_container.dart';
import '../../../../../core/widgets/product_card_widget.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../../core/navigation/route_names.dart';

// Feature Imports
import 'package:goshary_app/features/03_product_and_category/domain/entities/product.dart';
import 'package:goshary_app/features/03_product_and_category/data/datasources/product_remote_datasource.dart'; // یا Repository استعمال کریں

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
    // ہم یہاں existing datasource فنکشن استعمال کر رہے ہیں
    // یہ فنکشن API سے اس کیٹیگری کی پروڈکٹس لائے گا
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
              childAspectRatio: 0.65, // کارڈ کی اونچائی/چوڑائی
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCardWidget(
                productId: product.id,
                title: product.name,
                imageUrl: product.imageUrl,
                price: double.tryParse(product.price) ?? 0.0,
                regularPrice: product.regularPrice.isNotEmpty
                    ? double.tryParse(product.regularPrice)
                    : null,
                rating: product.rating,
                reviewCount: product.reviewCount,
                onTap: () {
                  // پروڈکٹ ڈیٹیل پر جائیں
                  context.pushNamed(
                      RouteNames.productDetails,
                      pathParameters: {'id': product.id.toString()}
                  );
                },
                onAddToCart: () {
                  // Add to Cart Logic (یہاں CartCubit کال کر سکتے ہیں)
                },
              );
            },
          );
        },
      ),
    );
  }
}