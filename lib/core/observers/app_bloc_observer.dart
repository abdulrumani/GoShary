import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// یہ کلاس پوری ایپ میں ہونے والی State Changes کو کنسول میں پرنٹ کرتی ہے۔
/// ڈیبگنگ کے لیے یہ بہت مفید ہے۔
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      print('🚀 Bloc Created: ${bloc.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print('🔄 State Changed in ${bloc.runtimeType}:\n'
          '   Current: ${change.currentState}\n'
          '   Next:    ${change.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('❌ Error in ${bloc.runtimeType}: $error');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      print('🗑️ Bloc Closed: ${bloc.runtimeType}');
    }
  }
}