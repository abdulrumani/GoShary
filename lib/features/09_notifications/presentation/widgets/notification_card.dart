import 'package:flutter/material.dart';
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../domain/entities/notification_item.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // آئیکن اور رنگ کا فیصلہ (Type کی بنیاد پر)
    IconData icon;
    Color color;
    Color bgColor;

    switch (notification.type) {
      case 'order':
        icon = Icons.local_shipping_outlined;
        color = Colors.blue;
        bgColor = Colors.blue.shade50;
        break;
      case 'promo':
        icon = Icons.percent;
        color = Colors.orange;
        bgColor = Colors.orange.shade50;
        break;
      case 'info':
      default:
        icon = Icons.notifications_outlined;
        color = AppColors.primary;
        bgColor = AppColors.inputFill;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // اگر Unread ہے تو ہلکا نیلا بیک گراؤنڈ، ورنہ سفید
          color: notification.isRead ? Colors.white : AppColors.primary.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.1),
          ),
          boxShadow: [
            if (notification.isRead)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Icon Container
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                // Unread Dot on Icon (Optional Style)
                if (!notification.isRead)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.error, // Red dot for attention
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1.5)),
                      ),
                    ),
                  ),
              ],
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
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.textTheme.titleSmall?.copyWith(
                            // اگر Unread ہے تو زیادہ بولڈ دکھائیں
                            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: notification.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}