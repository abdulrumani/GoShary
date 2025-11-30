import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// --- Background Handler ---
// یہ فنکشن کلاس سے باہر (Top Level) ہونا ضروری ہے تاکہ جب ایپ بند ہو
// تب بھی یہ بیک گراؤنڈ میں چل سکے۔
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🌙 Background Message Received: ${message.messageId}');
  // یہاں آپ لوکل ڈیٹا بیس میں نوٹیفکیشن محفوظ کر سکتے ہیں اگر چاہیں
}

class NotificationService {
  // سنگلٹن انسٹینس
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Android Channel (ہائی پرائیورٹی نوٹیفکیشنز کے لیے)
  final AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  bool _isInitialized = false;

  /// 🚀 1. سروس کو شروع کرنا (main.dart میں کال کریں)
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. پرمیشن مانگنا (iOS اور Android 13+ کے لیے ضروری ہے)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted permission');
      _setupAndroidChannel();
      _setupForegroundNotifications();
      _setupInteractions();

      // بیک گراؤنڈ ہینڈلر رجسٹر کریں
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      _isInitialized = true;
    } else {
      debugPrint('❌ User declined or has not accepted permission');
    }
  }

  /// 🔑 2. FCM ٹوکن حاصل کرنا (لاگ ان کے وقت سرور کو بھیجنے کے لیے)
  Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      debugPrint('🔥 FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Failed to get FCM token: $e');
      return null;
    }
  }

  /// 📱 3. Android Channel سیٹ اپ (صرف اینڈرائیڈ کے لیے)
  Future<void> _setupAndroidChannel() async {
    if (!Platform.isAndroid) return;

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  /// 🔔 4. اگر ایپ کھلی ہے (Foreground) تب بھی نوٹیفکیشن دکھانا
  void _setupForegroundNotifications() {
    // Local Notifications کی سیٹنگز
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // یقینی بنائیں کہ یہ آئیکن موجود ہے

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    _localNotifications.initialize(initSettings);

    // Firebase Listener: جب ایپ کھلی ہو اور میسج آئے
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // اگر نوٹیفکیشن ڈیٹا موجود ہے تو اسے لوکل نوٹیفکیشن کے ذریعے دکھائیں
      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          payload: message.data.toString(), // اگر کلک پر کچھ کرنا ہو
        );
      }
    });
  }

  /// 👆 5. جب یوزر نوٹیفکیشن پر کلک کرے
  void _setupInteractions() {
    // اگر ایپ مکمل بند تھی اور نوٹیفکیشن سے کھلی
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessageClick(message);
      }
    });

    // اگر ایپ بیک گراؤنڈ میں تھی اور کھولی گئی
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageClick);
  }

  void _handleMessageClick(RemoteMessage message) {
    debugPrint('👆 Notification Clicked: ${message.data}');
    // یہاں آپ AppRouter کے ذریعے نیویگیٹ کر سکتے ہیں
    // مثال کے طور پر: اگر آرڈر آئی ڈی ہے تو آرڈر ڈیٹیلز پر جائیں
    // if (message.data.containsKey('order_id')) { ... }
  }
}