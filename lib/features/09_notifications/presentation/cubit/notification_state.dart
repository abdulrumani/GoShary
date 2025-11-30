import '../../domain/entities/notification_item.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationItem> notifications;

  NotificationLoaded({required this.notifications});
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}