class AppConstants {
  // --- App Info ---
  static const String appName = 'Goshary Shop';
  static const String appVersion = '1.0.0';
  static const String defaultCurrency = 'SAR'; // یا 'PKR' آپ کی مرضی کے مطابق
  static const String fontFamily = 'Poppins';

  // --- Timeouts ---
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // --- Asset Base Paths ---
  static const String _imagePath = 'assets/images';
  static const String _iconPath = 'assets/icons';
  // static const String _animPath = 'assets/animations'; // اگر Lottie استعمال کریں

  // --- Images Assets ---
  // (یہ نام صرف مثال ہیں، آپ اپنی تصاویر کے ناموں کے مطابق انہیں تبدیل کر سکتے ہیں)
  static const String logo = '$_imagePath/logo.png';
  static const String logoDark = '$_imagePath/logo_dark.png';
  static const String placeholder = '$_imagePath/placeholder.png'; // جب امیج لوڈ نہ ہو
  static const String splashBanner = '$_imagePath/splash_banner.png';

  // --- Icons Assets ---
  // سوشل لاگ ان کے لیے
  static const String googleIcon = '$_iconPath/google.png';
  static const String facebookIcon = '$_iconPath/facebook.png';
  static const String appleIcon = '$_iconPath/apple.png';

  // پیمنٹ گیٹ ویز کے لیے
  static const String visaIcon = '$_iconPath/visa.png';
  static const String mastercardIcon = '$_iconPath/mastercard.png';
  static const String applePayIcon = '$_iconPath/apple_pay.png';
  static const String stcPayIcon = '$_iconPath/stc_pay.png';
  static const String tabbyIcon = '$_iconPath/tabby.png';
  static const String tamaraIcon = '$_iconPath/tamara.png';

  // --- Validation Regex ---
  // ای میل چیک کرنے کا پیٹرن
  static const String emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}