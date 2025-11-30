import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // پاس ورڈ دکھانے/چھپانے کی اسٹیٹ
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // شروع میں وہی ویلیو رکھیں جو پاس کی گئی ہے (پاس ورڈ ہے تو true)
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,

        // شروع میں آئیکن (اگر دیا گیا ہو)
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
            : null,

        // آخر میں آئیکن (پاس ورڈ کی صورت میں Eye Icon، ورنہ کسٹم آئیکن)
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
          ),
          onPressed: _toggleVisibility,
        )
            : widget.suffixIcon,
      ),
    );
  }
}