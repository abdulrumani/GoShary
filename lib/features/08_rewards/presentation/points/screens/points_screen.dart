import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/services/di_container.dart';
import '../../../../../core/widgets/loading_indicator.dart';

// Feature Imports
import '../../../domain/entities/reward_entities.dart';
import '../../../domain/usecases/get_points_usecase.dart';
import '../widgets/daily_checkin_widget.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  late Future<PointsData> _pointsFuture;
  bool _isCheckedIn = false; // Local state for demo

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  void _loadPoints() {
    _pointsFuture = sl<GetPointsData>().call();
  }

  void _handleCheckIn() {
    // Call API here (sl<RewardsRepository>().dailyCheckIn())
    setState(() {
      _isCheckedIn = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You earned 50 points!"),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("My Points"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<PointsData>(
        future: _pointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // اگر ڈیٹا نہ ہو تو خالی آبجیکٹ استعمال کریں
          final data = snapshot.data ?? PointsData(balance: 0, level: 'Bronze', history: []);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. Points Balance Circle
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 4),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.stars, color: Colors.amber, size: 28),
                            const SizedBox(height: 4),
                            Text(
                              "${data.balance}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              "Points",
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data.level, // e.g. "Gold Member"
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 2. Daily Check-in
                DailyCheckInWidget(
                  isCheckedIn: _isCheckedIn,
                  onCheckIn: _handleCheckIn,
                ),

                const SizedBox(height: 30),

                // 3. History List
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Points History", style: AppTypography.textTheme.titleMedium),
                ),
                const SizedBox(height: 16),

                if (data.history.isEmpty)
                  const Center(child: Text("No history yet", style: TextStyle(color: Colors.grey)))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.history.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = data.history[index];
                      final isPositive = item.points > 0;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                          child: Icon(
                            isPositive ? Icons.add : Icons.remove,
                            color: isPositive ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ),
                        title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(item.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        trailing: Text(
                          "${isPositive ? '+' : ''}${item.points}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isPositive ? Colors.green : Colors.red,
                            fontSize: 16,
                          ),
                        ),
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