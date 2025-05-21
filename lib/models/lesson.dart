class Lesson {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl; // Changed back to videoUrl for your custom implementation
  final String instructor;
  final String difficulty;
  final String duration;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.instructor,
    required this.difficulty,
    required this.duration,
  });
}

// Sample data
List<Lesson> sampleLessons = [
  Lesson(
    id: '1',
    title: 'Konsep Pemrograman',
    description: 'Pelajari dasar-dasar konsep pemrograman dengan contoh yang mudah dipahami. Kursus ini cocok untuk pemula yang ingin memulai perjalanan coding mereka.',
    thumbnailUrl: 'assets/images/thumbnail1.jpg',
    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Full YouTube URL - replace with your own
    instructor: 'John Doe',
    difficulty: 'Advanced',
    duration: '1h 20min',
  ),
  Lesson(
    id: '2',
    title: 'API dan REST',
    description: 'Pengenalan API dan REST untuk pengembangan aplikasi modern',
    thumbnailUrl: 'assets/images/thumbnail2.jpg',
    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Full YouTube URL - replace with your own
    instructor: 'Jane Smith',
    difficulty: 'Intermediate',
    duration: '45:00min',
  ),
  Lesson(
    id: '3',
    title: 'Flutter Basics',
    description: 'Pengenalan dasar Flutter untuk pembuatan aplikasi mobile',
    thumbnailUrl: 'assets/images/thumbnail3.jpg',
    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Full YouTube URL - replace with your own
    instructor: 'Alex Johnson',
    difficulty: 'Beginner',
    duration: '25:00min',
  ),
];
