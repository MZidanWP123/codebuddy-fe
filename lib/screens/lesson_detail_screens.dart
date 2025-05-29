import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import '../models/lesson.dart';
import '../models/notes.dart';
import '../widgets/custom_video_player.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _isNotesVisible = false;
  final TextEditingController _notesController = TextEditingController();
  bool _hasUnsavedChanges = false;

   @override
  void initState() {
    super.initState();
    _secureScreen();
  }

   Future<void> _secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleNotes() {
    setState(() {
      _isNotesVisible = !_isNotesVisible;
    });
  }

  void _saveNotes() {
    if (_notesController.text.trim().isEmpty) return;
    
    // In a real app, you would save this to a database
    final newNote = Note(
      id: DateTime.now().toString(),
      lessonId: widget.lesson.id,
      lessonTitle: widget.lesson.title,
      content: _notesController.text,
      createdAt: DateTime.now(),
    );
    
    // Add to the sample notes list
    sampleNotes.add(newNote);
    
    // Close the notes panel
    setState(() {
      _isNotesVisible = false;
      _notesController.clear();
      _hasUnsavedChanges = false;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved successfully')),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Unsaved changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Text(
                'Do you want to save or discard changes?',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _saveNotes();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D2A44),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Confirm'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isNotesVisible = false;
                    _notesController.clear();
                    _hasUnsavedChanges = false;
                  });
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // YouTube Video Player - Always visible at the top
          CustomVideoPlayer(youtubeUrl: widget.lesson.videoUrl),
          
          // Lesson details and notes section
          Expanded(
            child: Stack(
              children: [
                // Lesson details - scrollable
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lesson.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Instructor
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.lesson.instructor,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      
                      // Difficulty
                      Row(
                        children: [
                          const Icon(Icons.bar_chart, size: 16, color: Colors.grey),
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
                              widget.lesson.difficulty,
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Duration
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.lesson.duration,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.lesson.description),
                      
                      // Extra space for the button
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                
                // Take Notes button - fixed at bottom
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
                
                // Notes panel - slides up from bottom but doesn't cover video
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
                          // Header
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.lesson.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
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
                          
                          // Notes text area
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: _notesController,
                                maxLines: null,
                                expands: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Pelajari dasar-dasar pemrograman dengan contoh yang mudah dipahami. Kursus ini cocok untuk pemula yang ingin memulai perjalanan coding mereka.',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _hasUnsavedChanges = value.trim().isNotEmpty;
                                  });
                                },
                              ),
                            ),
                          ),
                          
                          // Save button
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
