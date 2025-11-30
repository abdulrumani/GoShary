import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // شیئرنگ کے لیے (نیچے نوٹ دیکھیں)
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/services/di_container.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../../../domain/entities/reward_entities.dart';
import '../../../domain/usecases/get_referral_data.dart';
import '../widgets/referral_code_widget.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  late Future<ReferralData> _referralFuture;

  @override
  void initState() {
    super.initState();
    _referralFuture = sl<GetReferralData>().call();
  }

  void _shareLink(String link) {
    // 'share_plus' پیکج استعمال کریں
    Share.share('Check out this amazing store! Use my code to get a discount: $link');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ShopLuxe Clean Look
      appBar: AppBar(
        title: const Text("Refer & Earn"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<ReferralData>(
        future: _referralFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data ??
              ReferralData(referralCode: "---", referralLink: "", totalEarnings: "0", totalReferrals: 0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 1. Hero Image / Illustration
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1), // Light Amber/Gold bg
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.card_giftcard, size: 60, color: Colors.orange),
                      const SizedBox(height: 16),
                      Text(
                        "Invite Friends, Get Rewards",
                        style: AppTypography.textTheme.titleLarge?.copyWith(color: Colors.orange[800]),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Earn \$5 for every friend who purchases.",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 2. Referral Code Widget
                ReferralCodeWidget(code: data.referralCode),

                const SizedBox(height: 30),

                // 3. Stats Grid
                Row(
                  children: [
                    _buildStatCard("Total Earnings", "\$${data.totalEarnings}", Icons.monetization_on_outlined, Colors.green),
                    const SizedBox(width: 16),
                    _buildStatCard("Successful Referrals", "${data.totalReferrals}", Icons.people_outline, Colors.blue),
                  ],
                ),

                const SizedBox(height: 40),

                // 4. How it works
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("How it works", style: AppTypography.textTheme.titleMedium),
                ),
                const SizedBox(height: 16),
                _buildStepRow("1", "Share your referral link with friends"),
                _buildStepRow("2", "Friend signs up and makes a purchase"),
                _buildStepRow("3", "You get \$5 in your wallet instantly"),

                const SizedBox(height: 40),

                // 5. Share Button
                CustomButton(
                  text: "Share Link",
                  onPressed: () => _shareLink(data.referralLink),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}