import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

// --- Auth Screens ---
import '../../features/00_splash/presentation/screens/splash_screen.dart';
import '../../features/01_auth/presentation/screens/welcome_screen.dart';
import '../../features/01_auth/presentation/screens/login_screen.dart';
import '../../features/01_auth/presentation/screens/signup_screen.dart';
import '../../features/01_auth/presentation/screens/otp_verification_screen.dart';

// --- Main Tab Screens ---
import '../../features/02_home/presentation/screens/home_screen.dart';
import '../../features/03_product_and_category/presentation/categories/screens/category_screen.dart';
import '../../features/06_wishlist/presentation/screens/wishlist_screen.dart';
import '../../features/04_cart/presentation/screens/cart_screen.dart';
import '../../features/07_account_and_support/presentation/dashboard/screens/account_dashboard_screen.dart';

// --- Product & Category Screens ---
import '../../features/03_product_and_category/presentation/product_details/screens/product_detail_screen.dart';
import '../../features/03_product_and_category/presentation/categories/screens/product_list_screen.dart';
import '../../features/03_product_and_category/presentation/reviews/screens/all_reviews_screen.dart';

// --- Checkout Screens ---
import '../../features/05_checkout/presentation/screens/checkout_screen.dart';
import '../../features/05_checkout/presentation/screens/payment_selection_screen.dart';

// --- Account & Support Screens ---
import '../../features/07_account_and_support/presentation/orders/screens/my_orders_screen.dart';
import '../../features/07_account_and_support/presentation/orders/screens/order_details_screen.dart';
import '../../features/07_account_and_support/presentation/tracking/screens/order_tracking_screen.dart';
import '../../features/07_account_and_support/presentation/address/screens/my_address_screen.dart';
import '../../features/07_account_and_support/presentation/address/screens/add_edit_address_screen.dart';
import '../../features/07_account_and_support/presentation/my_reviews/screens/my_reviews_screen.dart';
import '../../features/07_account_and_support/presentation/support/screens/customer_support_screen.dart';
import '../../features/07_account_and_support/presentation/settings/screens/settings_screen.dart';

// --- Rewards Screens ---
import '../../features/08_rewards/presentation/wallet/screens/wallet_screen.dart';
import '../../features/08_rewards/presentation/points/screens/points_screen.dart';
import '../../features/08_rewards/presentation/referral/screens/referral_screen.dart';

// --- Notification Screen ---
import '../../features/09_notifications/presentation/screens/notification_screen.dart';

// --- Entities (For arguments) ---
import '../../features/05_checkout/domain/entities/order.dart'; // For OrderAddress & OrderEntity

// --- Wrapper ---
import '../widgets/main_wrapper_scaffold.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // =======================================================================
      // 1. Splash & Auth Routes
      // =======================================================================
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: RouteNames.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),

      // =======================================================================
      // 2. Main Shell (Bottom Navigation)
      // =======================================================================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 2: Categories
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                name: RouteNames.categories,
                builder: (context, state) => const CategoryScreen(),
              ),
            ],
          ),
          // Tab 3: Wishlist
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wishlist',
                name: RouteNames.wishlist,
                builder: (context, state) => const WishlistScreen(),
              ),
            ],
          ),
          // Tab 4: Cart
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                name: RouteNames.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          // Tab 5: Account
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                name: RouteNames.account,
                builder: (context, state) => const AccountDashboardScreen(),
              ),
            ],
          ),
        ],
      ),

      // =======================================================================
      // 3. Product & Category Routes
      // =======================================================================
      GoRoute(
        path: '/product/:id',
        name: RouteNames.productDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '0';
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/product-list',
        name: 'product_list', // Note: Add this to RouteNames if not present
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ProductListScreen(
            categoryId: extra['id'],
            categoryName: extra['name'],
          );
        },
      ),
      GoRoute(
        path: '/product-reviews/:id',
        name: RouteNames.productReviews,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '0';
          return AllReviewsScreen(productId: id);
        },
      ),

      // =======================================================================
      // 4. Checkout Routes
      // =======================================================================
      GoRoute(
        path: '/checkout',
        name: RouteNames.checkout,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        name: RouteNames.paymentMethods,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final currentMethod = state.extra as String? ?? 'cod';
          return PaymentSelectionScreen(currentMethod: currentMethod);
        },
      ),

      // =======================================================================
      // 5. Account & Support Routes
      // =======================================================================
      GoRoute(
        path: '/my-orders',
        name: RouteNames.myOrders,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MyOrdersScreen(),
      ),
      GoRoute(
        path: '/order-details',
        name: RouteNames.orderDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return OrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        path: '/order-tracking',
        name: RouteNames.orderTracking,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          // اگر آرڈر ID پاس کیا گیا ہے تو لیں، ورنہ 0 (ٹیسٹنگ کے لیے)
          final orderId = state.extra as int? ?? 0;
          return OrderTrackingScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/my-addresses',
        name: 'my_addresses', // Add to RouteNames
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MyAddressScreen(),
      ),
      GoRoute(
        path: '/add-address',
        name: RouteNames.addAddress,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final addressToEdit = state.extra as OrderAddress?;
          return AddEditAddressScreen(addressToEdit: addressToEdit);
        },
      ),
      GoRoute(
        path: '/my-reviews',
        name: 'my_reviews', // Add to RouteNames
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MyReviewsScreen(),
      ),
      GoRoute(
        path: '/support',
        name: 'support', // Add to RouteNames
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CustomerSupportScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings', // Add to RouteNames
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),

      // =======================================================================
      // 6. Rewards & Notifications
      // =======================================================================
      GoRoute(
        path: '/wallet',
        name: RouteNames.wallet,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/points',
        name: RouteNames.points,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PointsScreen(),
      ),
      GoRoute(
        path: '/referral',
        name: RouteNames.referral,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReferralScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: RouteNames.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationScreen(),
      ),
    ],
  );
}