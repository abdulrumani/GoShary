import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_item.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  /// 🔔 نوٹیفکیشنز لوڈ کریں
  Future<void> loadNotifications() async {
    emit(NotificationLoading());

    try {
      // اصلی ایپ میں یہاں آپ Local Database (Hive/SQLite) یا API کال کریں گے۔
      // فی الحال ہم ShopLuxe Design  کے مطابق ڈیٹا دکھا رہے ہیں۔
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading

      final List<NotificationItem> mockNotifications = [
        NotificationItem(
          id: 1,
          title: "Your order has shipped!",
          body: "Package #SH-2847 is on its way. Track your delivery in real-time.",
          timeAgo: "now",
          isRead: false,
          type: "order",
        ),
        NotificationItem(
          id: 2,
          title: "Flash Sale Alert!",
          body: "Get up to 70% off on electronics. Limited time offer ends in 3 hours!",
          timeAgo: "1h ago",
          isRead: false,
          type: "promo",
        ),
        NotificationItem(
          id: 3,
          title: "Rate your recent purchase",
          body: "How was your experience with Wireless Headphones Pro? Share your feedback.",
          timeAgo: "3h ago",
          isRead: true,
          type: "info",
        ),
        NotificationItem(
          id: 4,
          title: "Payment Successful",
          body: "Your payment of \$127.99 has been processed successfully.",
          timeAgo: "1d ago",
          isRead: true,
          type: "order",
        ),
        NotificationItem(
          id: 5,
          title: "Item back in stock",
          body: "Good news! 'Smart Watch Ultra' from your wishlist is now available.",
          timeAgo: "1d ago",
          isRead: true,
          type: "info",
        ),
      ];

      emit(NotificationLoaded(notifications: mockNotifications));
    } catch (e) {
      emit(NotificationError(message: "Failed to load notifications"));
    }
  }

  /// 👀 مارک ایز ریڈ (Mark as Read)
  void markAsRead(int id) {
    if (state is NotificationLoaded) {
      final currentList = (state as NotificationLoaded).notifications;

      // لسٹ کو اپڈیٹ کریں
      final updatedList = currentList.map((item) {
        if (item.id == id) {
          return NotificationItem(
            id: item.id,
            title: item.title,
            body: item.body,
            timeAgo: item.timeAgo,
            isRead: true, // یہ تبدیل ہوا ہے
            type: item.type,
          );
        }
        return item;
      }).toList();

      emit(NotificationLoaded(notifications: updatedList));
    }
  }
}