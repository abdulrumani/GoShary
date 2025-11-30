class CartItemModel {
  final String key; // Cart Item Key (WooCommerce unique ID)
  final int productId;
  final String name;
  final String price; // یونٹ کی قیمت
  final int quantity;
  final String imageUrl;
  final Map<String, dynamic> variation; // Size/Color details
  final String lineSubtotal; // کل قیمت (Price x Quantity)

  CartItemModel({
    required this.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.variation,
    required this.lineSubtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Images کو پارس کرنا
    String img = '';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      img = json['images'][0]['src'] ?? '';
    }

    // Prices کو پارس کرنا (WooCommerce Store API cents میں دیتا ہے، اس لیے /100 کریں)
    // یا اگر سادہ API ہے تو سٹرنگ۔ Store API میں عام طور پر 'prices' کا آبجیکٹ ہوتا ہے۔
    String unitPrice = '0';
    String total = '0';

    if (json['prices'] != null) {
      unitPrice = (int.parse(json['prices']['price'] ?? '0') / 100).toString();
      total = (int.parse(json['totals']['line_subtotal'] ?? '0') / 100).toString();
    }

    return CartItemModel(
      key: json['key'] ?? '',
      productId: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: unitPrice,
      quantity: json['quantity'] ?? 1,
      imageUrl: img,
      variation: json['variation'] ?? {},
      lineSubtotal: total,
    );
  }
}