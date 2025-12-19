import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    required super.key,
    required super.productId,
    required super.name,
    required super.price,
    required super.quantity,
    required super.imageUrl,
    required super.variation,
    required super.lineSubtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // 1. Images Parsing (محفوظ طریقہ)
    String img = '';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      img = json['images'][0]['src'] ?? '';
    }

    // 2. Prices Parsing (محفوظ طریقہ)
    // WooCommerce Store API اکثر قیمتیں cents (پیسوں) میں بھیجتا ہے (e.g. 1000 = $10.00)
    // اور کبھی String تو کبھی Int میں بھیجتا ہے۔
    String unitPrice = '0.00';
    String total = '0.00';

    try {
      // Unit Price
      if (json['prices'] != null) {
        // پہلے String میں لیں، پھر ڈبل بنائیں
        var priceRaw = json['prices']['price']?.toString() ?? '0';
        // 100 سے تقسیم کریں تاکہ Cents سے Dollars/Rupees بن جائیں
        unitPrice = (double.parse(priceRaw) / 100).toStringAsFixed(2);
      }

      // Line Subtotal
      if (json['totals'] != null) {
        var totalRaw = json['totals']['line_subtotal']?.toString() ?? '0';
        total = (double.parse(totalRaw) / 100).toStringAsFixed(2);
      }
    } catch (e) {
      // اگر کوئی گڑبڑ ہو تو کنسول میں پرنٹ کریں، لیکن ایپ کریش نہ ہونے دیں
      print("⚠️ Error parsing cart prices: $e");
    }

    // 3. Variation Parsing
    // کبھی یہ خالی List [] ہوتی ہے اور کبھی Map {}
    Map<String, dynamic> variationData = {};
    if (json['variation'] != null) {
      if (json['variation'] is Map) {
        variationData = json['variation'] as Map<String, dynamic>;
      } else if (json['variation'] is List) {
        // اگر خالی لسٹ ہو تو اسے ignore کریں
        variationData = {};
      }
    }

    return CartItemModel(
      key: json['key']?.toString() ?? '',
      productId: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      price: unitPrice,
      quantity: json['quantity'] ?? 1,
      imageUrl: img,
      variation: variationData,
      lineSubtotal: total,
    );
  }
}