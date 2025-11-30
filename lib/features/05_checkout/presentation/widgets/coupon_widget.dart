import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';

class CouponWidget extends StatefulWidget {
  final Function(String) onApply;
  final VoidCallback? onRemove;
  final String? appliedCouponCode; // اگر کوپن لگا ہوا ہے تو یہاں پاس کریں
  final bool isLoading;

  const CouponWidget({
    super.key,
    required this.onApply,
    this.onRemove,
    this.appliedCouponCode,
    this.isLoading = false,
  });

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    [cite_start]// 1. اگر کوپن لگا ہوا ہے (Applied State) [cite: 212-213]
    if (widget.appliedCouponCode != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer, color: AppColors.success),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coupon Applied",
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.appliedCouponCode!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.error),
              onPressed: widget.onRemove,
              tooltip: "Remove Coupon",
            ),
          ],
        ),
      );
    }

    // 2. کوپن لگانے کی حالت (Input State)
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hintText: "Enter coupon code",
            controller: _controller,
            prefixIcon: Icons.local_offer_outlined,
          ),
        ),
        const SizedBox(width: 12),
        CustomButton(
          text: "Apply",
          width: 90,
          height: 50, // TextField کی اونچائی کے برابر
          isLoading: widget.isLoading,
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onApply(_controller.text.trim());
              // کی بورڈ بند کریں
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }
}