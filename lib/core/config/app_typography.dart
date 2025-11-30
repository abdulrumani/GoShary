import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // اگر آپ نے assets میں فونٹ شامل نہیں کیا، تو Flutter ڈیفالٹ سسٹم فونٹ استعمال کرے گا
  static const String fontFamily = 'Poppins';

  static TextTheme get textTheme {
    return const TextTheme(
      // 1. Headings (بڑے ٹائٹلز، جیسے "ShopLuxe" یا "Discover...")
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.5, // ٹائٹلز کو تھوڑا ٹائٹ رکھنے کے لیے
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),

      // 2. Titles (کارڈز کے ٹائٹلز، پروڈکٹ کے نام)
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),

      // 3. Body Text (پیراگراف، پروڈکٹ کی تفصیل)
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary, // تفصیلات کے لیے گرے رنگ
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),

      // 4. Labels & Buttons (بٹن کا ٹیکسٹ، نیویگیشن بار)
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.bold, // بٹن ٹیکسٹ تھوڑا بولڈ
        color: Colors.white, // عام طور پر پرائمری بٹن پر سفید ہوتا ہے
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      ),
    );
  }
}