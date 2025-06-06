class Note {
  final String id;
  final String noteTitle; // Sesuai dengan field note_title di database
  final String userId;
  final String courseId; // Sesuai dengan field course_id di database
  final String note;     // Sesuai dengan field note di database
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.noteTitle,
    required this.userId,
    required this.courseId,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  // Parsing dari satu objek JSON ke objek Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'].toString(),
      noteTitle: json['note_title'] ?? '',
      userId: json['user_id'].toString(),
      courseId: json['course_id'].toString(),
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.parse(json['created_at']),
    );
  }

  // Parsing dari List JSON ke List<Note>
  static List<Note> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Note.fromJson(json)).toList();
  }

  // Untuk mengubah Note jadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note_title': noteTitle,
      'user_id': userId,
      'course_id': courseId,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
