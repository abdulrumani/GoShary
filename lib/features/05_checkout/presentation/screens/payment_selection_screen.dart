import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final String currentMethod; // جو پہلے سے سلیکٹ ہے

  const PaymentSelectionScreen({
    super.key,
    this.currentMethod = 'cod', // Default Cash on Delivery
  });

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  late String _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.currentMethod;
  }

  void _onConfirmSelection() {
    // سلیکٹڈ میتھڈ اور اس کا ٹائٹل واپس بھیجیں
    String title = _getPaymentTitle(_selectedMethod);
    context.pop({'method': _selectedMethod, 'title': title});
  }

  String _getPaymentTitle(String method) {
    switch (method) {
      case 'apple_pay': return 'Apple Pay';
      case 'credit_card': return 'Credit/Debit Card';
      case 'cod': return 'Cash on Delivery';
      case 'tabby': return 'Tabby - Pay in 4';
      case 'tamara': return 'Tamara - Split in 3';
      default: return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Payment Methods"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Digital Wallets
                    Text("Digital Wallets", style: AppTypography.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      id: 'apple_pay',
                      title: 'Apple Pay',
                      icon: Icons.apple, // یا AppConstants.applePayIcon
                      isImage: false,
                    ),

                    const SizedBox(height: 24),

                    // 2. Credit & Debit Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Credit & Debit Cards", style: AppTypography.textTheme.titleMedium),
                        TextButton(
                          onPressed: () {
                            // Add New Card Screen Logic
                          },
                          child: const Text("+ Add New"),
                        )
                      ],
                    ),
                    _buildPaymentOption(
                      id: 'credit_card',
                      title: '**** **** **** 1234',
                      subtitle: 'Expires 12/25',
                      icon: Icons.credit_card,
                      isImage: false, // یہاں Visa/Master کا لوگو ہو سکتا ہے
                    ),

                    const SizedBox(height: 24),

                    // 3. Buy Now, Pay Later (BNPL)
                    Text("Buy Now, Pay Later", style: AppTypography.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      id: 'tabby',
                      title: 'Tabby',
                      subtitle: 'Split into 4 interest-free payments',
                      icon: Icons.payment,
                      isImage: false, // Use AppConstants.tabbyIcon
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      id: 'tamara',
                      title: 'Tamara',
                      subtitle: 'Split into 3 payments',
                      icon: Icons.payment,
                      isImage: false, // Use AppConstants.tamaraIcon
                    ),

                    const SizedBox(height: 24),

                    // 4. Cash on Delivery
                    Text("Other Methods", style: AppTypography.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      id: 'cod',
                      title: 'Cash on Delivery',
                      subtitle: 'Pay when you receive',
                      icon: Icons.money,
                      isImage: false,
                    ),
                  ],
                ),
              ),
            ),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: "Confirm Payment Method",
                onPressed: _onConfirmSelection,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    String? subtitle,
    required IconData icon,
    bool isImage = false,
  }) {
    final isSelected = _selectedMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedMethod = id);
      },
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
            // Icon / Logo
            Container(
              width: 50,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isImage
                  ? const Center(child: Icon(Icons.image)) // Image.asset(iconPath)
                  : Center(child: Icon(icon, color: Colors.black87, size: 20)),
            ),
            const SizedBox(width: 16),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),

            // Radio / Check Indicator
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary)
            else
              const Icon(Icons.circle_outlined, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}