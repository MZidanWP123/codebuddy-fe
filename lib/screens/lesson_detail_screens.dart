import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/notes.dart';
import '../services/note_services.dart';
import '../widgets/custom_video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonDetailScreen extends StatefulWidget {
  final Course course;

  const LessonDetailScreen({super.key, required this.course});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _isNotesVisible = false;
  final TextEditingController _notesController = TextEditingController();
  bool _hasUnsavedChanges = false;
  Note? _userNote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserNote();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserNote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = prefs.getInt('user_id') ?? 0;
      final notes = await NoteServices.getNotes(
        userId: currentUserId,
      ); // pakai userId dari auth/login
      final lessonNote = notes.firstWhere(
        (n) => n.lessonId == widget.course.id,
        orElse:
            () => Note(
              id: '',
              lessonTitle: widget.course.title,
              userId: currentUserId.toString(),
              lessonId: widget.course.id,
              content: '',
              createdAt: DateTime.now(),
            ),
      );

      setState(() {
        _userNote = lessonNote.id.isNotEmpty ? lessonNote : null;
        _notesController.text = lessonNote.content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // tampilkan snackbar kalau perlu
    }
  }

  void _toggleNotes() {
    setState(() {
      _isNotesVisible = !_isNotesVisible;
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    print("User ID dari SharedPreferences: $userId");
    final CourseId = int.parse(widget.course.id);
    final content = _notesController.text.trim();

    if (_userNote != null) {
      await NoteServices.updateNote(
        id: int.parse(_userNote!.id),
        content: content,
      );
    } else {
      await NoteServices.createNote(
        userId: userId,
        courseId: CourseId,
        content: content,
      );
    }

    setState(() {
      _isNotesVisible = false;
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note saved successfully')));
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Unsaved changes'),
            content: const Text('Do you want to save or discard changes?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _saveNotes();
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isNotesVisible = false;
                    _notesController.clear();
                    _hasUnsavedChanges = false;
                  });
                },
                child: const Text('Discard'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch & Write'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_hasUnsavedChanges) {
              _showUnsavedChangesDialog();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          CustomVideoPlayer(youtubeUrl: widget.course.videoUrl),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Instructor
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.course.instructor,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Difficulty
                      Row(
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.course.difficulty,
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(widget.course.description),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: _toggleNotes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D2A44),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Take Notes!'),
                    ),
                  ),
                ),
                if (_isNotesVisible)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1D2A44),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.course.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (_hasUnsavedChanges) {
                                      _showUnsavedChangesDialog();
                                    } else {
                                      _toggleNotes();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextField(
                                controller: _notesController,
                                maxLines: null,
                                expands: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Tulis catatanmu di sini...',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _hasUnsavedChanges =
                                        value.trim().isNotEmpty;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ElevatedButton(
                              onPressed: _saveNotes,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Save Notes'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
