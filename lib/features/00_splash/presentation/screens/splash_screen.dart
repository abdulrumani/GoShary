import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/di_container.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../../domain/entities/splash_offer.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Cubit فراہم کرنا (Dependency Injection کے ذریعے)
    return BlocProvider(
      create: (context) => sl<SplashCubit>()..loadSplashData(),
      child: const _SplashScreenContent(),
    );
  }
}

class _SplashScreenContent extends StatefulWidget {
  const _SplashScreenContent();

  @override
  State<_SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<_SplashScreenContent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- Navigation Logic ---
  void _onGetStarted(BuildContext context) async {
    final cubit = context.read<SplashCubit>();

    // 1. لوکل اسٹوریج میں محفوظ کریں کہ یوزر نے آن بورڈنگ دیکھ لی ہے
    await cubit.setOnboardingCompleted();

    // 2. اگلا روٹ حاصل کریں (Home یا Login)
    if (context.mounted) {
      final nextRoute = cubit.getNextRoute();
      context.go(nextRoute); // GoRouter کا استعمال
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // شروع میں سیاہ بیک گراؤنڈ
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          // اگر کوئی ایرر آئے تو آپ یہاں SnackBar دکھا سکتے ہیں
        },
        builder: (context, state) {
          // 1. Loading State (لوگو اور سپنر)
          if (state is SplashLoading || state is SplashInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo (Asset سے)
                  // Image.asset(AppConstants.logo, width: 150),
                  // فی الحال ٹیکسٹ لوگو استعمال کر رہے ہیں
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20),
                  LoadingIndicator(color: Colors.white),
                ],
              ),
            );
          }

          // 2. Loaded State (سلائیڈر دکھائیں)
          if (state is SplashLoaded) {
            // اگر API خالی لسٹ بھیجے، تو ڈیفالٹ ڈیٹا دکھائیں
            final offers = state.offers.isEmpty ? _getDefaultOffers() : state.offers;

            return Stack(
              children: [
                // --- A. Full Screen Slider ---
                PageView.builder(
                  controller: _pageController,
                  itemCount: offers.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildSliderItem(offers[index]);
                  },
                ),

                // --- B. Bottom Content (Text & Button) ---
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.3, 1.0],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page Indicator (Dots)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            offers.length,
                                (index) => _buildDot(index),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Title (Dynamic)
                        Text(
                          offers[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: AppTypography.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Subtitle (Dynamic)
                        Text(
                          offers[_currentPage].subtitle,
                          textAlign: TextAlign.center,
                          style: AppTypography.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Get Started Button
                        CustomButton(
                          text: "Get Started",
                          onPressed: () => _onGetStarted(context),
                          isOutlined: true, // سفید بارڈر والا بٹن
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // 3. Error State (اگر انٹرنیٹ نہ ہو)
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                const Text("Something went wrong", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Retry",
                  width: 150,
                  isOutlined: true,
                  onPressed: () => context.read<SplashCubit>().loadSplashData(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildSliderItem(SplashOffer offer) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CachedNetworkImage(
        imageUrl: offer.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: AppColors.primary),
        errorWidget: (context, url, error) => Container(
          color: AppColors.secondary,
          child: const Center(child: Icon(Icons.image, color: Colors.white54)),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  List<SplashOffer> _getDefaultOffers() {
    return [
      SplashOffer(
        id: 0,
        imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000&auto=format&fit=crop",
        title: "Welcome to ShopLuxe",
        subtitle: "Discover premium products at your fingertips",
      ),
    ];
  }
}