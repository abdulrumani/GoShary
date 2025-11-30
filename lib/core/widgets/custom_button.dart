import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final bool isOutlined; // اگر true ہو تو بٹن سفید ہوگا (Outlined)

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity, // ڈیفالٹ: پوری اسکرین کی چوڑائی
    this.height = 50.0,           // ڈیفالٹ اونچائی
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context),
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          // اگر بٹن Outlined ہے تو لوڈر سیاہ، ورنہ سفید
          color: isOutlined ? AppColors.primary : Colors.white,
        ),
      );
    }
    return Text(text);
  }
}