import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import 'package:goshary_app/core/config/app_colors.dart';
import 'package:goshary_app/core/config/app_typography.dart';
import 'package:goshary_app/core/services/di_container.dart';
import 'package:goshary_app/core/widgets/loading_indicator.dart';
import '../widgets/notification_card.dart'; // Import کریں

// Feature Imports
import '../../domain/entities/notification_item.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationCubit>()..loadNotifications(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: AppColors.primary),
            onPressed: () {
              // Mark all as read logic (Future Feature)
            },
            tooltip: "Mark all as read",
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 24),

              itemBuilder: (context, index) {
                final item = notifications[index];
                return NotificationCard(
                  notification: item,
                  onTap: () {
                    context.read<NotificationCubit>().markAsRead(item.id);
                  },
                );
              },

            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationItem item) {
    // آئیکن اور رنگ کا فیصلہ ٹائپ کی بنیاد پر
    IconData icon;
    Color color;

    switch (item.type) {
      case 'order':
        icon = Icons.local_shipping_outlined;
        color = Colors.blue;
        break;
      case 'promo':
        icon = Icons.percent; // [cite: 278]
        color = Colors.orange;
        break;
      case 'info':
      default:
        icon = Icons.notifications_outlined;
        color = AppColors.primary;
        break;
    }

    return GestureDetector(
      onTap: () {
        // ٹیپ کرنے پر اسے پڑھا ہوا (Read) مارک کریں
        context.read<NotificationCubit>().markAsRead(item.id);
      },
      child: Container(
        color: item.isRead ? Colors.white : AppColors.primary.withOpacity(0.03), // Unread highlight
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),

            // 2. Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: AppTypography.textTheme.titleSmall?.copyWith(
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.timeAgo, // [cite: 271, 282]
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: item.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Unread Dot
            if (!item.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 10),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "No Notifications Yet",
            style: AppTypography.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          const Text(
            "You're all caught up!", // [cite: 315]
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}