import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// App Imports
import 'app.dart';
import 'core/observers/app_bloc_observer.dart';
import 'core/services/di_container.dart' as di;

// نوٹ: جب آپ Firebase انسٹال کر لیں تب اسے ان-کمنٹ کریں
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() {
  // "Zone Mismatch" ایرر سے بچنے کے لیے ہم سب کچھ runZonedGuarded کے اندر کریں گے
  runZonedGuarded(
        () async {
      // 1. Flutter Bindings کو یقینی بنانا (یہ اب زون کے اندر ہے)
      WidgetsFlutterBinding.ensureInitialized();

      // 2. اسٹیٹس بار اور نیویگیشن بار کا اسٹائل
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // اسٹیٹس بار شفاف
          statusBarIconBrightness: Brightness.dark, // سیاہ آئیکنز
          systemNavigationBarColor: Colors.white, // نیویگیشن بار سفید
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // 3. ایپ کو صرف پورٹریٹ (سیدھا) موڈ میں لاک کرنا
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // 4. Firebase Setup (فی الحال بند ہے)
      /*
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      */

      // 5. Dependency Injection (DI) سیٹ اپ
      // یہ سب سے اہم ہے، یہاں APIs رجسٹر ہوتی ہیں
      await di.setupServiceLocator();

      // 6. Bloc Observer (کنسول میں اسٹیٹ دیکھنے کے لیے)
      Bloc.observer = AppBlocObserver();

      // 7. ایپ چلائیں
      runApp(const GosharyApp());
    },
        (error, stackTrace) {
      // 8. گلوبل ایرر ہینڈلنگ (یہاں کریش رپورٹ بھیج سکتے ہیں)
      debugPrint("🔴 Global Error Caught: $error");
      debugPrint(stackTrace.toString());
    },
  );
}