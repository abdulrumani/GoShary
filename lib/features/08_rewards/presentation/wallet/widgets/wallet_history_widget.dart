import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';
import 'package:goshary_app/features/08_rewards/domain/entities/reward_entities.dart';

class WalletHistoryWidget extends StatelessWidget {
  final WalletTransaction transaction;
  final String currency;

  const WalletHistoryWidget({
    super.key,
    required this.transaction,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == 'credit';
    final color = isCredit ? AppColors.success : AppColors.error;
    final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    final sign = isCredit ? "+" : "-";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),

          // Details & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.details,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            "$sign$currency${transaction.amount}",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}