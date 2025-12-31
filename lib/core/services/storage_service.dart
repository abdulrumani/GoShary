import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  // ================================================================
  // 1. Auth & User Data (لاگ ان اور یوزر ڈیٹا)
  // ================================================================

  /// یوزر کا ٹوکن محفوظ کریں
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

  /// یوزر کا ID حاصل کریں
  String? getUserId() {
    return _prefs.getString(StorageKeys.userId);
  }

  /// یوزر کا نام اور ای میل محفوظ کریں
  Future<void> saveUserInfo(String name, String email) async {
    await _prefs.setString(StorageKeys.userName, name);
    await _prefs.setString(StorageKeys.userEmail, email);
  }

  /// کیا یوزر لاگ ان ہے؟
  bool get hasToken => _prefs.containsKey(StorageKeys.userToken);

  // ================================================================
  // 2. Cart Token & Nonce (WooCommerce Store API) ✅ UPDATED
  // ================================================================

  /// کارٹ کا سیشن ٹوکن محفوظ کریں (تاکہ کارٹ خالی نہ ہو)
  Future<void> saveCartToken(String token) async {
    await _prefs.setString(StorageKeys.cartToken, token);
  }

  /// کارٹ کا ٹوکن حاصل کریں
  String? getCartToken() {
    return _prefs.getString(StorageKeys.cartToken);
  }

  /// ✅ نیا: Nonce (سیکیورٹی ٹوکن) محفوظ کریں
  Future<void> saveWcNonce(String nonce) async {
    await _prefs.setString(StorageKeys.wcNonce, nonce);
  }

  /// ✅ نیا: Nonce حاصل کریں
  String? getWcNonce() {
    return _prefs.getString(StorageKeys.wcNonce);
  }

  // ================================================================
  // 3. App Settings (زبان)
  // ================================================================

  /// ایپ کی زبان محفوظ کریں
  Future<bool> saveAppLanguage(String languageCode) async {
    return await _prefs.setString(StorageKeys.appLang, languageCode);
  }

  /// ایپ کی موجودہ زبان حاصل کریں
  String getAppLanguage() {
    return _prefs.getString(StorageKeys.appLang) ?? 'en';
  }

  // ================================================================
  // 4. Onboarding (کیا ایپ پہلی بار کھلی ہے؟)
  // ================================================================

  bool isFirstTimeOpen() {
    return _prefs.getBool(StorageKeys.isFirstTime) ?? true;
  }

  Future<bool> setFirstTimeChecked() async {
    return await _prefs.setBool(StorageKeys.isFirstTime, false);
  }

  // ================================================================
  // 5. Logout (ڈیٹا صاف کرنا)
  // ================================================================

  /// لاگ آؤٹ پر یوزر کا ڈیٹا صاف کریں
  Future<void> logout() async {
    await _prefs.remove(StorageKeys.userToken);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.userName);
    await _prefs.remove(StorageKeys.userEmail);
    // نوٹ: ہم Cart Token یا Nonce کو صاف نہیں کر رہے تاکہ یوزر کا کارٹ محفوظ رہے
  }
}