import '../constants/app_constants.dart';

class AppValidators {

  /// 📧 1. ای میل ویلیڈیشن
  /// چیک کرتا ہے کہ خالی تو نہیں اور فارمیٹ درست ہے
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // AppConstants سے Regex پیٹرن استعمال کریں
    final emailRegex = RegExp(AppConstants.emailRegex);

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null; // سب ٹھیک ہے
  }

  /// 🔒 2. پاس ورڈ ویلیڈیشن
  /// چیک کرتا ہے کہ کم از کم 6 ہندسے ہوں
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// 🔄 3. کنفرم پاس ورڈ (Sign Up کے لیے)
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// 📝 4. عام فیلڈز (Name, Address) کے لیے
  /// صرف یہ چیک کرتا ہے کہ فیلڈ خالی نہ ہو
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// 📱 5. فون نمبر ویلیڈیشن
  /// سادہ چیک: خالی نہ ہو اور کم از کم 9 ہندسے ہوں
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // صرف ہندسے ہیں یا نہیں؟
    // (یہ Regex صرف Digits کو allow کرتا ہے)
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter valid digits only';
    }

    if (value.length < 9) {
      return 'Phone number is too short';
    }

    return null;
  }
}