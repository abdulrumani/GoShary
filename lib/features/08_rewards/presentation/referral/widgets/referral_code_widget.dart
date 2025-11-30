import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard کے لیے
import '../../../../../core/config/app_colors.dart';

class ReferralCodeWidget extends StatelessWidget {
  final String code;

  const ReferralCodeWidget({super.key, required this.code});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Referral code copied!"),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Referral Code",
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                code,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => _copyToClipboard(context),
            icon: const Icon(Icons.copy, color: AppColors.primary),
            tooltip: "Copy Code",
          ),
        ],
      ),
    );
  }
}