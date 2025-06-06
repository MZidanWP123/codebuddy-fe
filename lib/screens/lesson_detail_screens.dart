import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const platform = MethodChannel('com.example.app/screenshot');

  @override
  void initState() {
    super.initState();
    _loadUserNote();
    _enableScreenshotPrevention();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _disableScreenshotPrevention();
    super.dispose();
  }

  Future<void> _enableScreenshotPrevention() async {
    try {
      await platform.invokeMethod('enableScreenshotPrevention');
    } on PlatformException catch (e) {
      print("Failed to enable screenshot prevention: '${e.message}'.");
    }
  }

  Future<void> _disableScreenshotPrevention() async {
    try {
      await platform.invokeMethod('disableScreenshotPrevention');
    } on PlatformException catch (e) {
      print("Failed to disable screenshot prevention: '${e.message}'.");
    }
  }

  Future<void> _loadUserNote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = prefs.getInt('user_id') ?? 0;

      // Coba ambil note yang sudah ada untuk course ini
      final existingNote = await NoteServices.getNoteByUserAndCourse(
        userId: currentUserId,
        courseId: widget.course.id,
      );

      setState(() {
        _userNote = existingNote;
        _notesController.text =
            existingNote?.note ?? ''; // Gunakan note bukan content
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading note: $e');
      setState(() => _isLoading = false);
    }
  }

  void _toggleNotes() {
    setState(() {
      _isNotesVisible = !_isNotesVisible;
    });
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 0;
      final courseId = int.parse(widget.course.id);
      final content = _notesController.text.trim();

      if (content.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Note cannot be empty')));
        return;
      }

      bool success = false;

      if (_userNote != null && _userNote!.id.isNotEmpty) {
        // Update existing note
        success = await NoteServices.updateNote(
          id: int.parse(_userNote!.id),
          content: content,
        );
      } else {
        // Create new note
        success = await NoteServices.createNote(
          userId: userId,
          courseId: courseId,
          content: content,
          courseTitle: widget.course.title,
        );
      }

      if (success) {
        // Reload note setelah save untuk mendapatkan data terbaru
        await _loadUserNote();

        setState(() {
          _isNotesVisible = false;
          _hasUnsavedChanges = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save note')));
      }
    } catch (e) {
      print('Error saving note: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error saving note')));
    }
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
                    _notesController.text =
                        _userNote?.note ?? ''; // Gunakan note bukan content
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
                      // Tampilkan indikator jika sudah ada note
                      if (_userNote != null && _userNote!.note.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.note, color: Colors.blue[600]),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'You have notes for this course',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      child: Text(
                        _userNote != null && _userNote!.note.isNotEmpty
                            ? 'Edit Notes'
                            : 'Take Notes!',
                      ),
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
                                        value.trim() != (_userNote?.note ?? '');
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
