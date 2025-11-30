import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class AppFormatters {

  /// 💰 1. قیمت کو فارمیٹ کرنا (Currency Formatting)
  /// ان پٹ: 1250.5
  /// آؤٹ پٹ: "SAR 1,250.50"
  static String formatPrice(dynamic price, {String? currency}) {
    if (price == null) return '0.00';

    double finalPrice = 0.0;

    // اگر پرائس String میں آ جائے تو اسے Double میں تبدیل کریں
    if (price is String) {
      finalPrice = double.tryParse(price) ?? 0.0;
    } else if (price is int) {
      finalPrice = price.toDouble();
    } else {
      finalPrice = price;
    }

    final format = NumberFormat("#,##0.00", "en_US");
    String formattedAmount = format.format(finalPrice);

    // اگر کوئی کرنسی پاس نہیں کی گئی تو ڈیفالٹ (SAR) استعمال کریں
    String symbol = currency ?? AppConstants.defaultCurrency;

    return '$symbol $formattedAmount';
  }

  /// 📅 2. تاریخ کو فارمیٹ کرنا (Date Formatting)
  /// آؤٹ پٹ: "12 Oct, 2025"
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    // 'MMM' = مہینے کا چھوٹا نام (Oct)
    // 'dd' = تاریخ (12)
    // 'yyyy' = سال (2025)
    return DateFormat('dd MMM, yyyy').format(date);
  }

  /// 🕒 3. مکمل تاریخ اور وقت (DateTime Formatting)
  /// آؤٹ پٹ: "12 Oct, 2025 - 10:30 AM"
  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM, yyyy - h:mm a').format(date);
  }

  /// 🔡 4. نام کا پہلا حرف بڑا کرنا (Capitalize)
  /// ان پٹ: "shoes" -> آؤٹ پٹ: "Shoes"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}