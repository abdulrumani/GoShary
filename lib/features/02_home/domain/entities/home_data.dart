class BannerEntity {
  final int id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String link; // اگر بینر پر کلک کرنے سے کہیں جانا ہو (Category/Product ID)

  BannerEntity({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.link = '',
  });
}