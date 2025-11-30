import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/services/di_container.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/loading_indicator.dart';

// Data Imports (Direct access for simplicity in this read-only screen)
import '../../../../05_checkout/domain/entities/order.dart'; // اگر آرڈر آبجیکٹ پاس کیا گیا ہو
import 'package:goshary_app/features/07_account_and_support/data/datasources/tracking_datasource.dart';
import '../widgets/tracking_stepper.dart';

class OrderTrackingScreen extends StatefulWidget {
  final int orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late Future<List<TrackingInfoModel>> _trackingFuture;

  @override
  void initState() {
    super.initState();
    // ٹریکنگ ڈیٹا لوڈ کریں
    _trackingFuture = sl<TrackingRemoteDataSource>().getOrderTracking(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Track Order #${widget.orderId}"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<TrackingInfoModel>>(
        future: _trackingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }

          // ٹریکنگ ڈیٹا (اگر API سے آئے)
          final trackingInfo = snapshot.data ?? [];

          // اگر API ڈیٹا نہیں ہے تو ہم Default Steps دکھائیں گے
          // (اصلی ایپ میں آپ Order Status پاس کر کے logic لگا سکتے ہیں)

          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. Map Placeholder (Visual Appeal)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    image: const DecorationImage(
                      image: NetworkImage("https://assets.website-files.com/5e832e12eb7ca02ee9064d42/5f7db426b676b95755fb2844_Snazzy%20Maps%20Custom%20Style.jpg"), // Mock Map
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_shipping, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text("Estimated Delivery: 2-3 Days", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 2. Timeline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Step 1: Order Placed
                      const TrackingStepper(
                        title: "Order Placed",
                        subtitle: "We have received your order.",
                        date: "Done",
                        isCompleted: true,
                      ),

                      // Step 2: Processing
                      const TrackingStepper(
                        title: "Order Confirmed",
                        subtitle: "Your order has been confirmed.",
                        date: "Done",
                        isCompleted: true,
                      ),

                      // Step 3: Shipped (Dynamic if tracking info exists)
                      if (trackingInfo.isNotEmpty) ...[
                        TrackingStepper(
                          title: "Shipped",
                          subtitle: "${trackingInfo.first.provider} - ${trackingInfo.first.trackingId}",
                          date: trackingInfo.first.dateShipped,
                          isCompleted: true,
                          isActive: true,
                        ),
                      ] else ...[
                        const TrackingStepper(
                          title: "Shipped",
                          subtitle: "Your package is on the way.",
                          date: "In Progress",
                          isCompleted: false,
                          isActive: true, // Currently active step
                        ),
                      ],

                      // Step 4: Delivered
                      const TrackingStepper(
                        title: "Delivered",
                        subtitle: "Package delivered to your address.",
                        date: "Pending",
                        isCompleted: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 3. Help Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CustomButton(
                    text: "Problem with order?",
                    isOutlined: true,
                    onPressed: () {
                      // Customer Support Screen
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}