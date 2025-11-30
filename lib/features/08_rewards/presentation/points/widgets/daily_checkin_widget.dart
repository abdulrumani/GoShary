import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';

class DailyCheckInWidget extends StatelessWidget {
  final bool isCheckedIn;
  final VoidCallback onCheckIn;

  const DailyCheckInWidget({
    super.key,
    required this.isCheckedIn,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCheckedIn
              ? [Colors.grey.shade300, Colors.grey.shade400]
              : [AppColors.primary, const Color(0xFF333333)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isCheckedIn ? Colors.transparent : AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCheckedIn ? "Checked In Today" : "Daily Check-in",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCheckedIn ? "Come back tomorrow!" : "Claim +50 Points now",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isCheckedIn)
            ElevatedButton(
              onPressed: onCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text("Claim"),
            )
          else
            const Icon(Icons.check_circle, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}