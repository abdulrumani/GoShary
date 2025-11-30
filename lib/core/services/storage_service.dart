import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  // ================================================================
  // 1. Auth & User Data (لاگ ان اور یوزر ڈیٹا)
  // ================================================================

  /// یوزر کا ٹوکن محفوظ کریں (Login کے بعد)
  Future<bool> saveUserToken(String token) async {
    return await _prefs.setString(StorageKeys.userToken, token);
  }

  /// یوزر کا ٹوکن حاصل کریں
  String? getUserToken() {
    return _prefs.getString(StorageKeys.userToken);
  }

  /// یوزر کا ID محفوظ کریں
  Future<bool> saveUserId(String id) async {
    return await _prefs.setString(StorageKeys.userId, id);
  }

  String? getUserId() {
    return _prefs.getString(StorageKeys.userId);
  }

  /// یوزر کا نام اور ای میل محفوظ کریں (پروفائل کے لیے)
  Future<void> saveUserInfo(String name, String email) async {
    await _prefs.setString(StorageKeys.userName, name);
    await _prefs.setString(StorageKeys.userEmail, email);
  }

  /// کیا یوزر لاگ ان ہے؟ (اگر ٹوکن موجود ہے تو ہاں)
  bool get hasToken => _prefs.containsKey(StorageKeys.userToken);

  // ================================================================
  // 2. App Settings (زبان اور تھیم)
  // ================================================================

  /// ایپ کی زبان محفوظ کریں (ar یا en)
  Future<bool> saveAppLanguage(String languageCode) async {
    return await _prefs.setString(StorageKeys.appLang, languageCode);
  }

  /// ایپ کی موجودہ زبان حاصل کریں (ڈیفالٹ 'en')
  String getAppLanguage() {
    return _prefs.getString(StorageKeys.appLang) ?? 'en';
  }

  // ================================================================
  // 3. Onboarding (کیا ایپ پہلی بار کھلی ہے؟)
  // ================================================================

  /// چیک کریں کہ کیا یہ پہلی بار ہے؟
  bool isFirstTimeOpen() {
    return _prefs.getBool(StorageKeys.isFirstTime) ?? true;
  }

  /// سیٹ کریں کہ اب پہلی بار نہیں رہی (Onboarding دکھانے کے بعد)
  Future<bool> setFirstTimeChecked() async {
    return await _prefs.setBool(StorageKeys.isFirstTime, false);
  }

  // ================================================================
  // 4. Logout (ڈیٹا صاف کرنا)
  // ================================================================

  /// جب یوزر لاگ آؤٹ کرے تو صرف یوزر کا ڈیٹا ہٹائیں (زبان وغیرہ رہنے دیں)
  Future<void> logout() async {
    await _prefs.remove(StorageKeys.userToken);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.userName);
    await _prefs.remove(StorageKeys.userEmail);
    // نوٹ: ہم appLang یا isFirstTime کو ریموو نہیں کر رہے
  }
}