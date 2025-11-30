import 'package:flutter/material.dart';

class RtlUtil {

  /// 🔄 1. کیا موجودہ لے آؤٹ RTL (دائیں سے بائیں) ہے؟
  /// یہ سب سے محفوظ طریقہ ہے کیونکہ یہ Flutter کی Directionality کو چیک کرتا ہے۔
  static bool isRtl(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// 🇸🇦 2. کیا موجودہ زبان عربی ہے؟
  /// یہ Locale کوڈ کو چیک کرتا ہے۔
  static bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  /// ↔️ 3. ویلیو کو سمت کے مطابق منتخب کرنا
  /// اگر RTL ہو تو پہلی ویلیو، ورنہ دوسری۔
  /// مثال: padding: EdgeInsets.only(left: RtlUtil.value(context, 0, 20))
  static T value<T>(BuildContext context, T rtlValue, T ltrValue) {
    return isRtl(context) ? rtlValue : ltrValue;
  }
}