import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ہم اگلی باری میں یہ فائلز بنائیں گے، لیکن میں نے انہیں یہاں لنک کر دیا ہے
// تاکہ یہ فائل فائنل رہے اور آپ کو دوبارہ ایڈٹ نہ کرنی پڑے۔
import 'app.dart';
import 'core/observers/app_bloc_observer.dart';
import 'core/services/di_container.dart' as di;

// نوٹ: جب آپ Firebase CLI سیٹ اپ کریں گے تو یہ فائل خود بخود جنریٹ ہو گی۔
// فی الحال میں اسے کمنٹ کر رہا ہوں تاکہ آپ کو ایرر نہ آئے۔
// import 'firebase_options.dart';

Future<void> main() async {
  // 1. Flutter Bindings کو یقینی بنانا
  WidgetsFlutterBinding.ensureInitialized();

  // 2. اسٹیٹس بار اور نیویگیشن بار کا رنگ سیٹ کرنا (شفاف اور صاف ڈیزائن کے لیے)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // اسٹیٹس بار شفاف
      statusBarIconBrightness: Brightness.dark, // آئیکنز سیاہ (لائٹ موڈ کے لیے)
      systemNavigationBarColor: Colors.white, // نیچے نیویگیشن بار سفید
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // 3. ایپ کو صرف پورٹریٹ موڈ (سیدھا) میں لاک کرنا (ای کامرس ایپس کے لیے بہتر ہے)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 4. Firebase کو شروع کرنا (Push Notifications اور Analytics کے لیے)
  // نوٹ: جب آپ 'flutterfire configure' کمانڈ چلائیں گے، تب آپ نیچے والی لائن کو ان-کمنٹ (Uncomment) کریں گے۔
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  // 5. Dependency Injection (DI) کو سیٹ اپ کرنا
  // یہ وہ جگہ ہے جہاں ہم اپنی تمام APIs اور Repositories کو رجسٹر کریں گے۔
  await di.setupServiceLocator();

  // 6. Bloc Observer کو سیٹ کرنا
  // یہ ہمیں کنسول میں دکھائے گا کہ ایپ کی اسٹیٹ (State) کب اور کیسے تبدیل ہو رہی ہے۔
  Bloc.observer = AppBlocObserver();

  // 7. ایپ کو رن کرنا
  // کسی بھی قسم کے غیر متوقع ایرر (Zone Error) کو ہینڈل کرنے کے لیے runZonedGuarded کا استعمال
  runZonedGuarded(
        () => runApp(const GosharyApp()),
        (error, stackTrace) {
      // یہاں آپ Firebase Crashlytics کو لاگ بھیج سکتے ہیں
      debugPrint("Global Error Caught: $error");
      debugPrint(stackTrace.toString());
    },
  );
}