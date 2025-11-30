import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    super.lastName = '',
    super.avatarUrl = '',
    super.token,
  });

  /// 🔐 1. JWT Login API سے ڈیٹا بنانا
  /// JWT Auth Plugin عام طور پر یہ ڈیٹا بھیجتا ہے:
  /// { "token": "...", "user_email": "...", "user_display_name": "..." }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0, // کبھی کبھی JWT ID نہیں بھیجتا، تو 0 فرض کریں
      email: json['user_email'] ?? '',
      firstName: json['user_display_name'] ?? '',
      lastName: '', // JWT عام طور پر الگ سے Last Name نہیں بھیجتا
      avatarUrl: json['avatar'] ?? '', // اگر اوتار کا URL ہو
      token: json['token'],
    );
  }

  /// 📝 2. WooCommerce Registration API سے ڈیٹا بنانا
  /// WooCommerce یہ ڈیٹا بھیجتا ہے:
  /// { "id": 12, "email": "...", "first_name": "...", "role": "customer" }
  factory UserModel.fromWooJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      // نوٹ: رجسٹریشن API عام طور پر ٹوکن نہیں بھیجتی۔
      // یوزر کو رجسٹر ہونے کے بعد دوبارہ لاگ ان کرنا پڑتا ہے، یا
      // ہم آٹو-لاگ ان کے لیے الگ لاجک لگاتے ہیں۔
      token: null,
    );
  }

  /// 💾 3. ڈیٹا کو لوکل اسٹوریج (Shared Prefs) کے لیے JSON میں بدلنا
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'token': token,
    };
  }
}