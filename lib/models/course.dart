class Course {
  final String id;
  final String title;
  final String videoUrl;
  final String description;
  final String thumbnailUrl;
  final String instructor;
  final String difficulty;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.instructor,
    required this.difficulty,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      videoUrl: json['url'] ?? '', // asumsi field "url" adalah video
      instructor: json['created_by'] ?? '',
      difficulty: json['level'] ?? '',
    );
  }
}
