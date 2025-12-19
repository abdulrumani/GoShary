import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Core Imports ---
import '../api/api_client.dart';
import '../api/interceptors/auth_interceptor.dart';
import '../api/interceptors/logging_interceptor.dart';
import 'storage_service.dart';
import 'notification_service.dart'; // ✅ New Import

// --- Feature 00: Splash ---
import '../../features/00_splash/data/datasources/splash_remote_datasource.dart';
import '../../features/00_splash/data/repositories/splash_repository_impl.dart';
import '../../features/00_splash/domain/repositories/splash_repository.dart';
import '../../features/00_splash/domain/usecases/get_splash_offers.dart';
import '../../features/00_splash/presentation/cubit/splash_cubit.dart';

// --- Feature 01: Auth ---
import '../../features/01_auth/data/datasources/auth_remote_datasource.dart';
import '../../features/01_auth/data/repositories/auth_repository_impl.dart';
import '../../features/01_auth/domain/repositories/auth_repository.dart';
import '../../features/01_auth/domain/usecases/login_usecase.dart';
import '../../features/01_auth/domain/usecases/signup_usecase.dart';
import '../../features/01_auth/domain/usecases/login_with_phone_usecase.dart';
import '../../features/01_auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/01_auth/domain/usecases/login_with_social_usecase.dart';
import '../../features/01_auth/presentation/bloc/auth_bloc.dart';

// --- Feature 02: Home ---
import '../../features/02_home/data/datasources/home_remote_datasource.dart';
import '../../features/02_home/data/repositories/home_repository_impl.dart';
import '../../features/02_home/domain/repositories/home_repository.dart';
import '../../features/02_home/domain/usecases/get_home_data.dart';
import '../../features/02_home/presentation/cubit/home_cubit.dart';

// --- Feature 03: Product & Category ---
import '../../features/03_product_and_category/data/datasources/product_remote_datasource.dart';
import '../../features/03_product_and_category/data/repositories/product_repository_impl.dart';
import '../../features/03_product_and_category/domain/repositories/product_repository.dart';
import '../../features/03_product_and_category/domain/usecases/get_product_details.dart';
import '../../features/03_product_and_category/domain/usecases/get_product_reviews.dart';
import '../../features/03_product_and_category/domain/usecases/get_related_products.dart';
import '../../features/03_product_and_category/domain/usecases/get_all_categories.dart';
import '../../features/03_product_and_category/presentation/product_details/cubit/product_detail_cubit.dart';
import '../../features/03_product_and_category/presentation/categories/cubit/category_cubit.dart';

// --- Feature 04: Cart ---
import '../../features/04_cart/data/datasources/cart_remote_datasource.dart';
import '../../features/04_cart/data/repositories/cart_repository_impl.dart';
import '../../features/04_cart/domain/repositories/cart_repository.dart';
import '../../features/04_cart/domain/usecases/get_cart.dart';
import '../../features/04_cart/domain/usecases/add_to_cart.dart';
import '../../features/04_cart/domain/usecases/update_cart_item.dart';
import '../../features/04_cart/domain/usecases/remove_cart_item.dart';
import '../../features/04_cart/presentation/cubit/cart_cubit.dart';

// --- Feature 05: Checkout ---
import '../../features/05_checkout/data/datasources/checkout_remote_datasource.dart';
import '../../features/05_checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/05_checkout/domain/repositories/checkout_repository.dart';
import '../../features/05_checkout/domain/usecases/apply_coupon_usecase.dart';
import '../../features/05_checkout/domain/usecases/place_order_usecase.dart';
import '../../features/05_checkout/presentation/bloc/checkout_bloc.dart';

// --- Feature 06: Wishlist ---
import '../../features/06_wishlist/data/datasources/wishlist_remote_datasource.dart';
import '../../features/06_wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../features/06_wishlist/domain/repositories/wishlist_repository.dart';
import '../../features/06_wishlist/domain/usecases/get_wishlist_usecase.dart';
import '../../features/06_wishlist/domain/usecases/toggle_wishlist_usecase.dart';
import '../../features/06_wishlist/presentation/cubit/wishlist_cubit.dart';

// --- Feature 07: Account & Support ---
import '../../features/07_account_and_support/data/datasources/order_datasource.dart';
import '../../features/07_account_and_support/data/datasources/tracking_datasource.dart';
import '../../features/07_account_and_support/data/repositories/order_repository_impl.dart';
import '../../features/07_account_and_support/domain/repositories/order_repository.dart';
import '../../features/07_account_and_support/domain/usecases/get_my_orders_usecase.dart';
import '../../features/07_account_and_support/presentation/orders/cubit/order_cubit.dart';

// --- Feature 08: Rewards ---
import '../../features/08_rewards/data/datasources/rewards_datasource.dart';
import '../../features/08_rewards/data/repositories/rewards_repository_impl.dart';
import '../../features/08_rewards/domain/repositories/rewards_repository.dart';
import '../../features/08_rewards/domain/usecases/get_wallet_usecase.dart';
import '../../features/08_rewards/domain/usecases/get_points_usecase.dart';
import '../../features/08_rewards/domain/usecases/get_referral_data.dart';

// --- Feature 09: Notifications ---
import '../../features/09_notifications/presentation/cubit/notification_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ================================================================
  // 1. External
  // ================================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // ================================================================
  // 2. Core
  // ================================================================
  sl.registerLazySingleton(() => StorageService(sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthInterceptor(sharedPreferences: sl()));
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => ApiClient(sharedPreferences: sl()));

  // Notification Service (Singleton)
  sl.registerLazySingleton(() => NotificationService());

  // ================================================================
  // 3. Features
  // ================================================================

  // --- Feature 00: Splash ---
  // Cubit
  sl.registerFactory(() => SplashCubit(getSplashOffers: sl(), storageService: sl()));
  // Use Cases
  sl.registerLazySingleton(() => GetSplashOffers(repository: sl()));
  // Repository
  sl.registerLazySingleton<SplashRepository>(
          () => SplashRepositoryImpl(remoteDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<SplashRemoteDataSource>(
          () => SplashRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 01: Auth ---
  // Bloc
  sl.registerFactory(() => AuthBloc(
    loginUser: sl(),
    signupUser: sl(),
    loginWithSocial: sl(),
    storageService: sl(),
  ));
  // Use Cases
  sl.registerLazySingleton(() => LoginUser(repository: sl()));
  sl.registerLazySingleton(() => SignupUser(repository: sl()));
  sl.registerLazySingleton(() => LoginWithPhone(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtp(repository: sl()));
  sl.registerLazySingleton(() => LoginWithSocial(repository: sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(remoteDataSource: sl(), storageService: sl()));
  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 02: Home ---
  // Cubit
  sl.registerFactory(() => HomeCubit(getHomeData: sl()));
  // Use Cases
  sl.registerLazySingleton(() => GetHomeData(repository: sl()));
  // Repository
  sl.registerLazySingleton<HomeRepository>(
          () => HomeRepositoryImpl(remoteDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<HomeRemoteDataSource>(
          () => HomeRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 03: Product & Category ---
  // Cubits
  sl.registerFactory(() => ProductDetailCubit(
    getProductDetails: sl(),
    getProductReviews: sl(),
    getRelatedProducts: sl(),
  ));
  sl.registerFactory(() => CategoryCubit(getAllCategories: sl()));
  // Use Cases
  sl.registerLazySingleton(() => GetProductDetails(repository: sl()));
  sl.registerLazySingleton(() => GetProductReviews(repository: sl()));
  sl.registerLazySingleton(() => GetRelatedProducts(repository: sl()));
  sl.registerLazySingleton(() => GetAllCategories(repository: sl()));
  // Repository
  sl.registerLazySingleton<ProductRepository>(
          () => ProductRepositoryImpl(remoteDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<ProductRemoteDataSource>(
          () => ProductRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 04: Cart ---
  // Cubit
  sl.registerFactory(() => CartCubit(
    getCart: sl(),
    addToCartUseCase: sl(),
    updateCartItemUseCase: sl(),
    removeCartItemUseCase: sl(),
  ));
  // Use Cases
  sl.registerLazySingleton(() => GetCart(repository: sl()));
  sl.registerLazySingleton(() => AddToCart(repository: sl()));
  sl.registerLazySingleton(() => UpdateCartItem(repository: sl()));
  sl.registerLazySingleton(() => RemoveCartItem(repository: sl()));
  // Repository
  sl.registerLazySingleton<CartRepository>(
          () => CartRepositoryImpl(remoteDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<CartRemoteDataSource>(
          () => CartRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 05: Checkout ---
  // Bloc
  sl.registerFactory(() => CheckoutBloc(
    applyCoupon: sl(),
    placeOrder: sl(),
  ));
  // Use Cases
  sl.registerLazySingleton(() => ApplyCoupon(repository: sl()));
  sl.registerLazySingleton(() => PlaceOrder(repository: sl()));
  // Repository
  sl.registerLazySingleton<CheckoutRepository>(
          () => CheckoutRepositoryImpl(remoteDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<CheckoutRemoteDataSource>(
          () => CheckoutRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 06: Wishlist ---
  // Cubit
  sl.registerFactory(() => WishlistCubit(
    getWishlistUseCase: sl(),
    toggleWishlistUseCase: sl(),
  ));
  // Use Cases
  sl.registerLazySingleton(() => GetWishlist(repository: sl()));
  sl.registerLazySingleton(() => ToggleWishlist(repository: sl()));
  // Repository
  sl.registerLazySingleton<WishlistRepository>(
          () => WishlistRepositoryImpl(remoteDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<WishlistRemoteDataSource>(
          () => WishlistRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 07: Account & Support ---
  // Cubit
  sl.registerFactory(() => OrderCubit(
    getMyOrders: sl(),
    storageService: sl(),
  ));
  // Use Cases
  sl.registerLazySingleton(() => GetMyOrders(repository: sl()));
  // Repository
  sl.registerLazySingleton<OrderRepository>(
          () => OrderRepositoryImpl(remoteDataSource: sl()));
  // Data Sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
          () => OrderRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<TrackingRemoteDataSource>(
          () => TrackingRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 08: Rewards ---
  // Use Cases
  sl.registerLazySingleton(() => GetWalletData(repository: sl()));
  sl.registerLazySingleton(() => GetPointsData(repository: sl()));
  sl.registerLazySingleton(() => GetReferralData(repository: sl()));
  // Repository
  sl.registerLazySingleton<RewardsRepository>(
          () => RewardsRepositoryImpl(remoteDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<RewardsRemoteDataSource>(
          () => RewardsRemoteDataSourceImpl(apiClient: sl()));

  // --- Feature 09: Notifications ---
  // Cubit
  sl.registerFactory(() => NotificationCubit());
}