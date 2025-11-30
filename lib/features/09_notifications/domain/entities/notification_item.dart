class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String timeAgo; // e.g., "2m ago", "1h ago"
  final bool isRead;
  final String type; // 'order', 'promo', 'info'

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.isRead,
    required this.type,
  });
}