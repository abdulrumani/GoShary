import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goshary_app/core/config/app_typography.dart';
import 'app_colors.dart';
//import 'app_typography.dart';

class AppTheme {
  // --- Light Theme (ڈیفالٹ) ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,

      // 1. Font Setup (انگریزی اور عربی دونوں کے لیے اچھا فونٹ)
      fontFamily: 'Poppins', // (ہمیں یہ فونٹ assets میں ڈالنا ہوگا، یا System font استعمال ہوگا)

      // 2. App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark, // اسٹیٹس بار کے آئیکنز سیاہ
      ),

      // 3. Button Theme (ShopLuxe Style: Black rounded buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white, // بٹن کا ٹیکسٹ سفید
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // مکمل گول (Pill Shape)
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 4. Outlined Button Theme (سفید بٹن، سیاہ بارڈر کے ساتھ)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 5. Text Button Theme (جیسے "See All" یا "Forgot Password")
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 6. Input Decoration (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // فیلڈز کے کنارے تھوڑے گول
          borderSide: BorderSide.none, // ڈیفالٹ میں کوئی بارڈر نہیں
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5), // کلک کرنے پر سیاہ بارڈر
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
      ),

      /*// 7. Card Theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05), // بہت ہلکا شیڈو
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // کارڈز کے کونے گول [cite: 190]
        ),
      ),*/

      // 8. Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }

  // --- Dark Theme (مستقبل کے لیے) ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.white, // ڈارک موڈ میں پرائمری رنگ سفید ہو سکتا ہے
      scaffoldBackgroundColor: const Color(0xFF121212),
      // ... باقی سیٹنگز یہاں آئیں گی
      textTheme: AppTypography.textTheme,
    );
  }
}