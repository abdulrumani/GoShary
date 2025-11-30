import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:goshary_app/core/config/app_colors.dart';

import 'package:goshary_app/core/config/app_colors.dart';
import 'package:goshary_app/core/config/app_typography.dart';
import 'package:goshary_app/core/utils/formatters.dart';
import 'package:goshary_app/features/03_product_and_category/domain/entities/review.dart';

class ReviewListWidget extends StatelessWidget {
  final Review review;

  const ReviewListWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // تاریخ کو پارس کریں (اگر فارمیٹ درست ہو)
    DateTime? reviewDate;
    try {
      reviewDate = DateTime.parse(review.date);
    } catch (e) {
      // تاریخ پارس نہ ہو سکی
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputFill.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Rating, Date
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: review.avatarUrl.isNotEmpty
                    ? NetworkImage(review.avatarUrl)
                    : null,
                backgroundColor: Colors.grey[300],
                child: review.avatarUrl.isEmpty
                    ? Text(
                  review.reviewerName.isNotEmpty ? review.reviewerName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.reviewerName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        if (review.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: AppColors.success),
                        ]
                      ],
                    ),
                    if (reviewDate != null)
                      Text(
                        AppFormatters.formatDate(reviewDate), // e.g., 12 Oct, 2023
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              // Stars
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Text(
                      "${review.rating}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review Content
          // چونکہ WooCommerce HTML بھیجتا ہے، ہم Html ویجیٹ استعمال کریں گے
          Html(
            data: review.reviewContent,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14),
                color: AppColors.textPrimary,
                maxLines: 10,
              ),
            },
          ),
        ],
      ),
    );
  }
}