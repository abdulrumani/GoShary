import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final Function(String method, String title) onMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOption(context, 'cod', 'Cash on Delivery', Icons.money),
        const SizedBox(height: 12),
        _buildOption(context, 'bacs', 'Direct Bank Transfer', Icons.account_balance),
        const SizedBox(height: 12),
        _buildOption(context, 'cheque', 'Check Payments', Icons.featured_play_list_outlined),
        // یہاں آپ Stripe/Credit Card کا آپشن بھی شامل کر سکتے ہیں
      ],
    );
  }

  Widget _buildOption(BuildContext context, String method, String title, IconData icon) {
    final isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () => onMethodSelected(method, title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}