import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/wallet_history_widget.dart'; // Import کریں

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/services/di_container.dart';
import '../../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import 'package:goshary_app/features/08_rewards/domain/entities/reward_entities.dart'; // WalletData, WalletTransaction
import '../../../domain/usecases/get_wallet_usecase.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<WalletData> _walletFuture;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  void _loadWalletData() {
    // UseCase کو کال کریں (DI کے ذریعے)
    _walletFuture = sl<GetWalletData>().call();
  }

  void _onTopUp() {
    // Top Up Logic (e.g., Show Dialog or Navigate to Payment)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Top-up feature coming soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("My Wallet"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                _loadWalletData();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<WalletData>(
        future: _walletFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No wallet data available"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary, // Black
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Balance",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                          const Icon(Icons.account_balance_wallet, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${data.currency}${data.balance}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _onTopUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Top Up Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 2. History Header
                Text("Transaction History", style: AppTypography.textTheme.titleMedium),
                const SizedBox(height: 16),

                // 3. Transactions List
                if (data.transactions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: Text("No transactions yet.", style: TextStyle(color: Colors.grey))),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.transactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return WalletHistoryWidget(
                        transaction: data.transactions[index],
                        currency: data.currency,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
