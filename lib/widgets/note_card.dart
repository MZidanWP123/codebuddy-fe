import 'package:flutter/material.dart';
import '../models/notes.dart';
import 'package:intl/intl.dart';
import '../screens/lesson_detail_screens.dart';
import '../services/courses_services.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  // Navigasi ke course detail
  void _navigateToCourse(BuildContext context) async {
    try {
      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Ambil detail course berdasarkan courseId
      final courseId = int.parse(note.courseId);
      final course = await CourseServices.getCourseById(courseId);
      
      // Tutup dialog loading
      Navigator.pop(context);
      
      // Navigasi ke course detail
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(course: course),
        ),
      );
    } catch (e) {
      // Tutup dialog loading jika error
      Navigator.pop(context);
      
      // Tampilkan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd').format(note.createdAt);
    
    // Perbaikan: Gunakan Color.fromRGBO untuk menggantikan withOpacity yang deprecated
    final backgroundColor = Color.fromRGBO(29, 42, 68, 0.1); // Menggantikan Color(0xFF1D2A44).withOpacity(0.1)
    
    return GestureDetector(
      onTap: () => _navigateToCourse(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                note.noteTitle, // Diubah dari lessonTitle ke noteTitle
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2A44),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                note.note, // Diubah dari content ke note
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
