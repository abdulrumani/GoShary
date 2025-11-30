class Category {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final int count; // اس کیٹیگری میں کتنی پروڈکٹس ہیں

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.count,
  });
}