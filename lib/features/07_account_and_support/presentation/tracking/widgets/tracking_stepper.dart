import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';

class TrackingStepper extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String date;
  final bool isCompleted;
  final bool isLast;
  final bool isActive;

  const TrackingStepper({
    super.key,
    required this.title,
    this.subtitle,
    required this.date,
    required this.isCompleted,
    this.isLast = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Timeline Line & Dot
        Column(
          children: [
            // Dot
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted || isActive ? AppColors.primary : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted || isActive ? AppColors.primary : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            // Line
            if (!isLast)
              Container(
                width: 2,
                height: 60, // فاصلہ
                color: isCompleted ? AppColors.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),

        // 2. Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted || isActive ? Colors.black : AppColors.textSecondary,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    subtitle!,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 4),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: TextStyle(
                    color: isCompleted || isActive ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 40), // Bottom spacing matching line height
            ],
          ),
        ),
      ],
    );
  }
}