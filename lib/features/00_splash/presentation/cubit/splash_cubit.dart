import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/usecases/get_splash_offers.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetSplashOffers getSplashOffers;
  final StorageService storageService;

  SplashCubit({
    required this.getSplashOffers,
    required this.storageService,
  }) : super(SplashInitial());

  /// 🚀 1. ڈیٹا لوڈ کرنا
  Future<void> loadSplashData() async {
    try {
      emit(SplashLoading());

      // API سے ڈیٹا لائیں
      final offers = await getSplashOffers();

      // کم از کم 2 سیکنڈ کا وقفہ (تاکہ سپلیش اسکرین فورا غائب نہ ہو جائے)
      await Future.delayed(const Duration(seconds: 2));

      if (offers.isEmpty) {
        // اگر کوئی آفر نہیں ہے، تب بھی ہم اسے Loaded کہیں گے
        // تاکہ ایپ آگے بڑھ سکے (خالی لسٹ کے ساتھ)
        emit(SplashLoaded(offers: []));
      } else {
        emit(SplashLoaded(offers: offers));
      }
    } catch (e) {
      emit(SplashError(message: "Failed to load offers"));
    }
  }

  /// 🔄 2. نیویگیشن چیک (اگلا قدم کیا ہے؟)
  /// یہ فنکشن ہم UI میں کال کریں گے جب ٹائمر ختم ہوگا یا یوزر "Skip" دبائے گا
  String getNextRoute() {
    // 1. کیا یوزر لاگ ان ہے؟
    final hasToken = storageService.hasToken;
    // 2. کیا ایپ پہلی بار کھلی ہے؟
    final isFirstTime = storageService.isFirstTimeOpen();

    if (hasToken) {
      return '/home'; // اگر لاگ ان ہے تو ہوم پر جائیں
    } else if (isFirstTime) {
      return '/welcome'; // اگر پہلی بار ہے تو ویلکم/آن بورڈنگ پر
    } else {
      return '/login'; // ورنہ لاگ ان پر (یا آپ ویلکم پر بھی بھیج سکتے ہیں)
    }
  }

  /// جب یوزر سپلیش سے آگے بڑھ جائے تو یہ سیٹ کریں
  Future<void> setOnboardingCompleted() async {
    await storageService.setFirstTimeChecked();
  }
}