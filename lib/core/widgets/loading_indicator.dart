import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 30.0, // ڈیفالٹ سائز
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          // اگر کوئی رنگ نہیں دیا گیا تو ایپ کا Primary (سیاہ) رنگ استعمال ہوگا
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
          // لوڈر کے پیچھے ہلکا سا گرے ٹریک (Premium Feel کے لیے)
          backgroundColor: AppColors.border.withOpacity(0.5),
        ),
      ),
    );
  }
}