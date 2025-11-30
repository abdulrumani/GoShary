class ApiEndpoints {
  // اپنی ویب سائٹ کا اصل URL یہاں لکھیں
  static const String baseUrl = 'https://goshary.sa/wp-json/';

  // --- Auth Endpoints ---
  static const String login = 'jwt-auth/v1/token'; // (JWT Auth Plugin)
  static const String register = 'wc/v3/customers'; // (WooCommerce)

  // --- Product Endpoints ---
  static const String products = 'wc/v3/products';
  static const String categories = 'wc/v3/products/categories';

  // --- Keys (Consumer Keys for WooCommerce) ---
  // اگر آپ HTTPS استعمال کر رہے ہیں تو ان کی ضرورت شاید نہ پڑے،
  // لیکن WooCommerce API اکثر ان کو مانگتا ہے۔
  static const String consumerKey = 'ck_0d9b60f83f0adf0a4833ef375646268a9fe5609d';
  static const String consumerSecret = 'cs_015e101722ea8963589ea03ccf83d5dc845b0ece';
}