class Note {
  final String id;
  final String lessonTitle;
  final String userId;
  final String lessonId;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.lessonTitle,
    required this.userId,
    required this.lessonId,
    required this.content,
    required this.createdAt,
  });

  // Parsing dari satu objek JSON ke objek Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'].toString(),
      lessonTitle: json['lesson_title'] ?? '',
      userId: json['user_id'].toString(),
      lessonId: json['lesson_id'].toString(),
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Parsing dari List JSON ke List<Note>
  static List<Note> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Note.fromJson(json)).toList();
  }

  // (Opsional) Untuk mengubah Note jadi JSON (berguna saat membuat atau update note)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_title': lessonTitle,
      'user_id': userId,
      'lesson_id': lessonId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
