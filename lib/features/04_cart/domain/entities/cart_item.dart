class CartItem {
  final String key; // آئٹم کی منفرد چابی (Update/Delete کے لیے)
  final int productId;
  final String name;
  final String price;
  final int quantity;
  final String imageUrl;
  final Map<String, dynamic> variation; // Size, Color details
  final String lineSubtotal; // کل قیمت

  CartItem({
    required this.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.variation,
    required this.lineSubtotal,
  });
}