import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import 'package:goshary_app/core/config/app_colors.dart';
import 'package:goshary_app/core/config/app_typography.dart';
import 'package:goshary_app/core/services/di_container.dart';
import 'package:goshary_app/core/widgets/loading_indicator.dart';

// Feature Imports
import 'package:goshary_app/features/03_product_and_category/domain/usecases/get_product_reviews.dart';
import 'package:goshary_app/features/03_product_and_category/domain/entities/review.dart';
import '../widgets/review_list_widget.dart'; // نیچے بنائی گئی فائل

class AllReviewsScreen extends StatefulWidget {
  final String productId;

  const AllReviewsScreen({super.key, required this.productId});

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    // UseCase کو براہ راست کال کر رہے ہیں (Dependency Injection کے ذریعے)
    _reviewsFuture = sl<GetProductReviews>().call(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reviews & Ratings"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reviews yet."));
          }

          final reviews = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. Rating Summary Section
                _buildRatingSummary(reviews),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // 2. Reviews List [cite: 164-184]
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return ReviewListWidget(review: reviews[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Rating Summary Helper ---
  Widget _buildRatingSummary(List<Review> reviews) {
    // اوسط ریٹنگ کا حساب
    double totalRating = 0;
    for (var r in reviews) totalRating += r.rating;
    final average = reviews.isNotEmpty ? totalRating / reviews.length : 0.0;

    // سٹارز کا بریک ڈاؤن (5 Star, 4 Star, etc.)
    final counts = [0, 0, 0, 0, 0]; // index 4 is 5 stars, index 0 is 1 star
    for (var r in reviews) {
      if (r.rating >= 1 && r.rating <= 5) {
        counts[r.rating - 1]++;
      }
    }

    return Row(
      children: [
        // Left Side: Average Rating
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(
                average.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "out of 5",
                style: AppTypography.textTheme.bodySmall,
              ),
              Text(
                "${reviews.length} ratings",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        // Right Side: Progress Bars
        Expanded(
          flex: 7,
          child: Column(
            children: List.generate(5, (index) {
              final starLevel = 5 - index; // 5, 4, 3...
              final count = counts[starLevel - 1];
              final percentage = reviews.isEmpty ? 0.0 : count / reviews.length;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        "$starLevel ★",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: AppColors.inputFill,
                        color: AppColors.warning,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text(
                        "$count",
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}