import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // سٹار ریٹنگ دینے کے لیے
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_textfield.dart';

// Feature Imports
import '../../../../03_product_and_category/domain/entities/review.dart';
import '../../../../03_product_and_category/presentation/reviews/widgets/review_list_widget.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data for "To Review" (خریدے گئے آئٹمز)
  final List<Map<String, dynamic>> _toReviewList = [
    {
      "id": 1,
      "name": "Wireless Headphones Sony",
      "image": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1000&auto=format&fit=crop",
      "date": "Purchased on 12 Oct, 2023",
    },
    {
      "id": 2,
      "name": "Smart Watch Series 7",
      "image": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1000&auto=format&fit=crop",
      "date": "Purchased on 05 Nov, 2023",
    },
  ];

  // Mock Data for "History" (پرانے ریویوز)
  final List<Review> _historyList = [
    Review(
      id: 101,
      reviewerName: "You",
      reviewContent: "Great product! The sound quality is amazing and noise cancellation works perfectly.",
      rating: 5,
      date: "2023-10-15T10:00:00",
      avatarUrl: "",
      isVerified: true,
    ),
    Review(
      id: 102,
      reviewerName: "You",
      reviewContent: "Good quality but delivery was a bit late.",
      rating: 4,
      date: "2023-09-20T14:30:00",
      avatarUrl: "",
      isVerified: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Write Review Dialog ---
  void _showWriteReviewDialog(BuildContext context, String productName) {
    double rating = 0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Review $productName", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Rate your experience"),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => const Icon(Icons.star, color: AppColors.warning),
              onRatingUpdate: (val) {
                rating = val;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: "Write your feedback here...",
              controller: commentController,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Submit Logic Here
              if (rating > 0) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Review Submitted Successfully!"), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("My Reviews"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: "To Review"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: To Review List
          _buildToReviewList(),

          // Tab 2: History List
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildToReviewList() {
    if (_toReviewList.isEmpty) {
      return const Center(child: Text("No pending reviews"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _toReviewList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = _toReviewList[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              // Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item['image'],
                    fit: BoxFit.cover,
                    errorWidget: (c, u, e) => const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(item['date'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),

                    // Write Review Button
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () => _showWriteReviewDialog(context, item['name']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text("Write Review", style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    if (_historyList.isEmpty) {
      return const Center(child: Text("No reviews submitted yet"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _historyList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        // ہم Feature 03 کا ReviewListWidget دوبارہ استعمال کر رہے ہیں
        return ReviewListWidget(review: _historyList[index]);
      },
    );
  }
}