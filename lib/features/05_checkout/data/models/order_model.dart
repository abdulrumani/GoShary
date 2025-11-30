import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.status,
    required super.total,
    required super.dateCreated,
    required super.paymentMethod,
    required super.paymentMethodTitle,
    required super.billing,
    required super.shipping,
    required super.lineItems,
  });

  /// 📥 API سے ڈیٹا پڑھنا (Get Orders)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'pending',
      total: json['total'] ?? '0.00',
      dateCreated: json['date_created'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paymentMethodTitle: json['payment_method_title'] ?? '',
      billing: OrderAddressModel.fromJson(json['billing'] ?? {}),
      shipping: OrderAddressModel.fromJson(json['shipping'] ?? {}),
      lineItems: (json['line_items'] as List? ?? [])
          .map((e) => OrderLineItemModel.fromJson(e))
          .toList(),
    );
  }

  /// 📤 API کو ڈیٹا بھیجنا (Create Order)
  Map<String, dynamic> toJson() {
    return {
      'payment_method': paymentMethod,
      'payment_method_title': paymentMethodTitle,
      'set_paid': true, // عام طور پر ہم اسے true رکھتے ہیں اگر پیمنٹ ہو گئی ہو
      'billing': (billing as OrderAddressModel).toJson(),
      'shipping': (shipping as OrderAddressModel).toJson(),
      'line_items': lineItems
          .map((e) => (e as OrderLineItemModel).toJson())
          .toList(),
    };
  }
}

// --- Helper Models ---

class OrderAddressModel extends OrderAddress {
  OrderAddressModel({
    required super.firstName,
    required super.lastName,
    required super.address1,
    required super.city,
    required super.state,
    required super.postcode,
    required super.country,
    required super.email,
    required super.phone,
  });

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderAddressModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address1: json['address_1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address_1': address1,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'email': email,
      'phone': phone,
    };
  }
}

class OrderLineItemModel extends OrderLineItem {
  OrderLineItemModel({
    required super.productId,
    required super.name,
    required super.quantity,
    required super.total,
  });

  factory OrderLineItemModel.fromJson(Map<String, dynamic> json) {
    return OrderLineItemModel(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      total: json['total'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      // 'total' بھیجنے کی ضرورت نہیں، سرور خود حساب لگائے گا
    };
  }
}