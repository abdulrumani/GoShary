import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/config/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/services/di_container.dart' as di;

// Feature Imports
import 'features/01_auth/presentation/bloc/auth_bloc.dart';
import 'features/04_cart/presentation/cubit/cart_cubit.dart';
import 'features/06_wishlist/presentation/cubit/wishlist_cubit.dart';
import 'features/09_notifications/presentation/cubit/notification_cubit.dart';

class GosharyApp extends StatelessWidget {
  const GosharyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 1. Auth Bloc
        BlocProvider(create: (_) => di.sl<AuthBloc>()),

        // 2. Cart Cubit (Global - تاکہ ہر جگہ دستیاب ہو)
        BlocProvider(create: (_) => di.sl<CartCubit>()..loadCart()),

        // 3. Wishlist Cubit (Global)
        BlocProvider(create: (_) => di.sl<WishlistCubit>()..loadWishlist()),

        // 4. Notification Cubit
        BlocProvider(create: (_) => di.sl<NotificationCubit>()..loadNotifications()),
      ],
      child: MaterialApp.router(
        title: 'Goshary Shop',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
        locale: const Locale('en'),
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}