class Review {
  final int id;
  final String reviewerName;
  final String reviewContent;
  final int rating;
  final String date;
  final String avatarUrl;
  final bool isVerified;

  Review({
    required this.id,
    required this.reviewerName,
    required this.reviewContent,
    required this.rating,
    required this.date,
    required this.avatarUrl,
    required this.isVerified,
  });
}