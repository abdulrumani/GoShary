import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Core Imports
import 'core/config/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/services/di_container.dart' as di;

// Feature Imports (Global Blocs/Cubits)
import 'features/01_auth/presentation/bloc/auth_bloc.dart';
import 'features/04_cart/presentation/cubit/cart_cubit.dart';
import 'features/06_wishlist/presentation/cubit/wishlist_cubit.dart';
import 'features/09_notifications/presentation/cubit/notification_cubit.dart';

class GosharyApp extends StatelessWidget {
  const GosharyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider: یہ وہ جگہ ہے جہاں ہم گلوبل اسٹیٹ (Global State) رکھتے ہیں۔
    // یہ Blocs پوری ایپ میں ہر اسکرین پر دستیاب ہوں گے۔
    return MultiBlocProvider(
      providers: [
        // 1. Auth Bloc (یوزر لاگ ان ہے یا نہیں؟)
        BlocProvider(create: (_) => di.sl<AuthBloc>()),

        // 2. Cart Cubit (کارٹ کا ڈیٹا فورا لوڈ کریں تاکہ بیج اور لسٹ اپڈیٹ رہے)
        BlocProvider(create: (_) => di.sl<CartCubit>()..loadCart()),

        // 3. Wishlist Cubit (وش لسٹ بھی شروع میں لوڈ کر لیں)
        BlocProvider(create: (_) => di.sl<WishlistCubit>()..loadWishlist()),

        // 4. Notification Cubit
        BlocProvider(create: (_) => di.sl<NotificationCubit>()..loadNotifications()),
      ],
      child: MaterialApp.router(
        title: 'Goshary Shop', // ایپ کا ٹائٹل
        debugShowCheckedModeBanner: false, // ڈیبگ ربن ہٹائیں

        // --- تھیم سیٹ اپ (Theme Setup) ---
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme, // اگر ڈارک موڈ بنایا ہو
        themeMode: ThemeMode.light, // فی الحال لائٹ موڈ فکس ہے

        // --- نیویگیشن / روٹنگ (Routing) ---
        routerConfig: AppRouter.router,

        // --- زبان اور لوکلائزیشن (Localization) ---
        locale: const Locale('en'), // ڈیفالٹ زبان
        supportedLocales: const [
          Locale('en', 'US'), // انگریزی
          Locale('ar', 'SA'), // عربی
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // یہ فنکشن ڈیوائس کی زبان کے مطابق ایپ کی زبان سیٹ کرتا ہے
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale?.languageCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first; // اگر میچ نہ ملے تو انگریزی
        },
      ),
    );
  }
}