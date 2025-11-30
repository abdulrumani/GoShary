import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goshary_app/core/widgets/custom_button.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/services/di_container.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_slider_widget.dart';
import '../widgets/home_category_list.dart';
import '../widgets/home_product_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png', // اگر لوگو نہ ہو تو ٹیکسٹ استعمال کریں
          height: 30,
          errorBuilder: (c, o, s) => const Text(
            "ShopLuxe",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () => context.pushNamed(RouteNames.notifications),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: GestureDetector(
              onTap: () {
                // سرچ اسکرین پر جائیں (Future Feature)
                // context.pushNamed(RouteNames.search);
              },
              child: const AbsorbPointer(
                child: CustomTextField(
                  hintText: "Search products, brands...",
                  prefixIcon: Icons.search,
                  readOnly: true, // تاکہ کی بورڈ نہ کھلے، صرف ٹیپ ہو
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          } else if (state is HomeLoaded) {
            final data = state.homeData;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeCubit>().loadHomeData();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Banners Slider [cite: 65-66]
                    if (data.banners.isNotEmpty)
                      HomeSliderWidget(banners: data.banners),

                    const SizedBox(height: 20),

                    // 2. Categories [cite: 69-80]
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Shop by Category", style: AppTypography.textTheme.titleMedium),
                          GestureDetector(
                            onTap: () => context.goNamed(RouteNames.categories), // Tab Switch
                            child: Text("See All", style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    HomeCategoryList(categories: data.categories),

                    const SizedBox(height: 24),

                    // 3. Latest Products [cite: 81-90]
                    HomeProductCarousel(
                      title: "Latest Products",
                      products: data.latestProducts,
                      onSeeAllTap: () {
                        // Navigate to product listing
                      },
                    ),

                    const SizedBox(height: 24),

                    // 4. Sale Banner / Section [cite: 91-96]
                    if (data.saleProducts.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0), // ہلکا سرخ
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Flash Sale", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.error)),
                                  Text("Up to 50% off on selected items", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: "Shop Now",
                              width: 100,
                              height: 35,
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      HomeProductCarousel(
                        title: "Special Offers",
                        products: data.saleProducts,
                        isSale: true,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // 5. Featured / Trending [cite: 97-104]
                    HomeProductCarousel(
                      title: "Trending Items",
                      products: data.featuredProducts,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}