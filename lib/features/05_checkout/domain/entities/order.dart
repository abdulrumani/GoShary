class OrderEntity {
  final int id;
  final String status; // e.g., 'processing', 'completed'
  final String total;
  final String dateCreated;
  final String paymentMethod;
  final String paymentMethodTitle;
  final OrderAddress billing;
  final OrderAddress shipping;
  final List<OrderLineItem> lineItems;

  OrderEntity({
    required this.id,
    required this.status,
    required this.total,
    required this.dateCreated,
    required this.paymentMethod,
    required this.paymentMethodTitle,
    required this.billing,
    required this.shipping,
    required this.lineItems,
  });
}

// ایڈریس کا ڈیٹا
class OrderAddress {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String email;
  final String phone;

  OrderAddress({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.email,
    required this.phone,
  });
}

// آرڈر کے اندر موجود پروڈکٹس
class OrderLineItem {
  final int productId;
  final String name;
  final int quantity;
  final String total;

  OrderLineItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.total,
  });
}