import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import 'package:goshary_app/core/config/app_colors.dart';
import 'package:goshary_app/core/config/app_typography.dart';
import 'package:goshary_app/core/navigation/route_names.dart';
import 'package:goshary_app/core/services/di_container.dart';

// Feature Imports
import 'package:goshary_app/features/01_auth/presentation/bloc/auth_bloc.dart';
import 'package:goshary_app/features/01_auth/presentation/bloc/auth_event.dart';
import 'package:goshary_app/features/01_auth/presentation/bloc/auth_state.dart';

class AccountDashboardScreen extends StatelessWidget {
  const AccountDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthBloc پہلے سے Global ہے (app.dart میں)، اس لیے یہاں دوبارہ Provide کرنے کی ضرورت نہیں
    // لیکن اگر آپ چاہیں کہ یہاں یوزر ڈیٹا ریفریش ہو تو الگ Cubit بنا سکتے ہیں۔
    // فی الحال ہم AuthBloc کی State استعمال کریں گے۔

    return const _AccountView();
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  void _onLogout(BuildContext context) {
    // لاگ آؤٹ ڈائیلاگ دکھائیں
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // ڈائیلاگ بند کریں
              // لاگ آؤٹ ایونٹ بھیجیں
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text("Log Out", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // لاگ آؤٹ ہونے پر ویلکم اسکرین پر واپس جائیں
          context.goNamed(RouteNames.welcome);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          title: const Text("My Account"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 1. User Profile Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    String name = "Guest User";
                    String email = "Sign in to see your profile";
                    String avatarUrl = "";

                    if (state is AuthSuccess) {
                      name = "${state.user.firstName} ${state.user.lastName}";
                      email = state.user.email;
                      avatarUrl = state.user.avatarUrl;
                    }

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.inputFill,
                          backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                          child: avatarUrl.isEmpty
                              ? Text(name[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary))
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: AppTypography.textTheme.titleLarge),
                              Text(email, style: AppTypography.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                          onPressed: () {
                            // Edit Profile Screen
                          },
                        )
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 2. Stats Grid (Points, Status, Wallet) [cite: 228-233]
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard("2,450", "Points", Icons.stars, Colors.amber),
                    const SizedBox(width: 12),
                    _buildStatCard("Gold", "Member", Icons.workspace_premium, Colors.purple),
                    const SizedBox(width: 12),
                    _buildStatCard("\$125", "Wallet", Icons.account_balance_wallet, AppColors.success),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Menu Options
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildMenuTile(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      title: "My Orders",
                      subtitle: "View order history",
                      onTap: () => context.pushNamed(RouteNames.myOrders), // ✅ یہ پہلے سے ٹھیک تھا
                    ),
                    _buildMenuTile(
                      context,
                      icon: Icons.local_shipping_outlined,
                      title: "Shipment Tracking",
                      subtitle: "Track your packages",
                      // 👇 ٹریکنگ اسکرین کے لیے (پہلے آرڈر کی ضرورت ہو سکتی ہے، فی الحال ٹیسٹ کے لیے ڈائریکٹ روٹ)
                      // اصلی ایپ میں ٹریکنگ ہمیشہ آرڈر لسٹ کے اندر سے کھلتی ہے،
                      // لیکن اگر آپ الگ اسکرین رکھنا چاہتے ہیں تو اسے روٹر میں ایڈ کرنا ہوگا
                      onTap: () => context.pushNamed(RouteNames.myOrders),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuTile(
                      context,
                      icon: Icons.account_balance_wallet_outlined,
                      title: "My Wallet & Cashback",
                      subtitle: "Balance: \$125.00",
                      // 👇 والیٹ اسکرین
                      onTap: () => context.pushNamed(RouteNames.wallet),
                    ),
                    _buildMenuTile(
                      context,
                      icon: Icons.card_giftcard,
                      title: "Coin & Point System",
                      subtitle: "2,450 points available",
                      // 👇 پوائنٹس اسکرین
                      onTap: () => context.pushNamed(RouteNames.points),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuTile(
                      context,
                      icon: Icons.people_outline,
                      title: "Referral & Affiliation",
                      subtitle: "Share and earn rewards",
                      // 👇 ریفرل اسکرین
                      onTap: () => context.pushNamed(RouteNames.referral),
                    ),
                    _buildMenuTile(
                      context,
                      icon: Icons.rate_review_outlined,
                      title: "My Reviews",
                      subtitle: "12 reviews submitted",
                      // 👇 ریویوز اسکرین (اگر روٹر میں ایڈ نہیں تو پہلے ایڈ کریں)
                      onTap: () => context.pushNamed(RouteNames.productReviews, pathParameters: {'id': '0'}), // عارضی ID
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Settings & Support
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildMenuTile(
                      context,
                      icon: Icons.headset_mic_outlined,
                      title: "Customer Support",
                      subtitle: "Get help 24/7",
                      onTap: () {
                        // Open Support Chat
                      },
                    ),
                    _buildMenuTile(
                      context,
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      subtitle: "Account preferences",
                      onTap: () {
                        // Open Settings
                      },
                    ),
                    _buildMenuTile(
                      context,
                      icon: Icons.lock_outline,
                      title: "Privacy & Security",
                      subtitle: "Manage your data",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppColors.error),
                      title: const Text("Log Out", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                      onTap: () => _onLogout(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text("App Version 1.0.0", style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}