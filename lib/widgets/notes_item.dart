import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Tambahkan import ini untuk debugPrint
import '../models/notes.dart';
import 'package:intl/intl.dart';
import '../models/course.dart';
import '../screens/lesson_detail_screens.dart';
import '../services/courses_services.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({super.key, required this.note});

  // Navigasi ke course detail dengan debugging yang lebih detail
  void _navigateToCourse(BuildContext context) async {
    try {
      debugPrint('=== DEBUGGING NAVIGATION ===');
      debugPrint('Note item tapped: ${note.noteTitle}');
      debugPrint('Course ID from note: ${note.courseId}');
      debugPrint('Course ID type: ${note.courseId.runtimeType}');
      
      // Validasi course ID
      if (note.courseId.isEmpty) {
        throw Exception('Course ID is empty');
      }

      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Parse course ID
      int courseId;
      try {
        courseId = int.parse(note.courseId);
        debugPrint('Parsed course ID: $courseId');
      } catch (e) {
        throw Exception('Invalid course ID format: ${note.courseId}');
      }

      // Coba ambil course dengan method utama
      Course? foundCourse; // Ubah menjadi nullable
      try {
        debugPrint('Attempting to fetch course with getCourseById...');
        foundCourse = await CourseServices.getCourseById(courseId);
        debugPrint('Course found via getCourseById: ${foundCourse.title}');
      } catch (e) {
        debugPrint('getCourseById failed: $e');
        debugPrint('Trying alternative method...');
        
        // Coba method alternatif - ambil semua course dan cari yang sesuai
        try {
          final allCourses = await CourseServices.fetchAllCourses();
          debugPrint('Fetched ${allCourses.length} courses');
          
          // Debug: Print semua course ID yang tersedia
          for (var c in allCourses) {
            debugPrint('Available course: ID=${c.id}, Title=${c.title}');
          }
          
          foundCourse = allCourses.firstWhere(
            (c) => c.id == note.courseId, // Bandingkan sebagai string
            orElse: () => throw Exception('Course not found in list'),
          );
          debugPrint('Course found via alternative method: ${foundCourse.title}');
        } catch (e2) {
          debugPrint('Alternative method also failed: $e2');
          foundCourse = null; // Set null jika tidak ditemukan
        }
      }
      
      // Tutup dialog loading
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Pastikan course ditemukan sebelum navigasi
      if (foundCourse == null) {
        throw Exception('Course not found with ID: ${note.courseId}');
      }
      
      // Navigasi ke course detail
      debugPrint('Navigating to LessonDetailScreen...');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(course: foundCourse!), // Gunakan ! karena sudah dicek null
        ),
      );
      debugPrint('Navigation completed successfully');
      
    } catch (e) {
      debugPrint('=== ERROR IN NAVIGATION ===');
      debugPrint('Error: $e');
      
      // Tutup dialog loading jika masih terbuka
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Tampilkan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open course: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Details',
            textColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error Details'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error: ${e.toString()}'),
                        const SizedBox(height: 10),
                        Text('Note Title: ${note.noteTitle}'),
                        Text('Course ID: ${note.courseId}'),
                        Text('Note Content: ${note.note}'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd').format(note.createdAt);
    
    return GestureDetector(
      onTap: () {
        debugPrint('=== NOTE ITEM TAPPED ===');
        debugPrint('Note Title: ${note.noteTitle}');
        debugPrint('Course ID: ${note.courseId}');
        debugPrint('Note Content Preview: ${note.note.length > 50 ? note.note.substring(0, 50) + "..." : note.note}');
        _navigateToCourse(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(29, 42, 68, 0.1),
          borderRadius: BorderRadius.circular(8),
          // Tambahkan border untuk visual feedback
          border: Border.all(
            color: const Color.fromRGBO(29, 42, 68, 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Date container
            Container(
              width: 50,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF1D2A44),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      note.noteTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2A44),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.note,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            
            // Arrow icon untuk menunjukkan bahwa item bisa diklik
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF1D2A44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
