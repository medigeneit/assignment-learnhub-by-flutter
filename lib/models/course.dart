class Course {
  final int id;
  final String title;
  final String instructor;
  final int categoryId;
  final String shortSummary;
  final String description;
  final double price;
  final double rating;
  final int durationMinutes;
  final String thumbnail;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.categoryId,
    required this.shortSummary,
    required this.description,
    required this.price,
    required this.rating,
    required this.durationMinutes,
    required this.thumbnail,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      categoryId: json['categoryId'] as int,
      shortSummary: json['shortSummary'] as String,
      description: json['description'] as String,
      // The API can send 1200 (int) or 499.5 (double), so read it as num first.
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int,
      thumbnail: json['thumbnail'] as String,
    );
  }
}
