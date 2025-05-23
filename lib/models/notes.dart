class Note {
  final String id;
  final String lessonId;
  final String lessonTitle;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    required this.content,
    required this.createdAt,
  });
}

// Sample data
List<Note> sampleNotes = [
  Note(
    id: '1',
    lessonId: '1',
    lessonTitle: 'Konsep Pemrograman',
    content: 'Variabel adalah tempat penyimpanan data dalam program. Tipe data menentukan jenis nilai yang dapat disimpan.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Note(
    id: '2',
    lessonId: '2',
    lessonTitle: 'API dan REST',
    content: 'REST API menggunakan HTTP methods seperti GET, POST, PUT, DELETE untuk operasi CRUD.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
