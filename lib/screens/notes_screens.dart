import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notes.dart';
import '../services/note_services.dart';
import '../widgets/notes_item.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserNotes();
    _searchController.addListener(_filterNotes);
  }

  Future<void> _loadUserNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;

    try {
      final notes = await NoteServices.getNotes(userId: userId);
      setState(() {
        _notes = notes;
        _filteredNotes = notes;
        _isLoading = false;
      });
    } catch (e) {
      // Gunakan debugPrint sebagai pengganti print untuk production
      debugPrint('Error loading notes: $e');
      setState(() => _isLoading = false);
    }
  }

  // Fungsi search yang diperbaiki
    void _filterNotes() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredNotes =
            _notes.where((note) {
              return note.noteTitle.toLowerCase().contains(
                    query,
                  ) || // Diubah dari lessonTitle ke noteTitle
                  note.note.toLowerCase().contains(
                    query,
                  ); // Diubah dari content ke note
            }).toList();
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Notes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.transparent,
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D2A44),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _notes.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Notes-pana.png',
                                height: 200,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  _searchController.text.isNotEmpty
                                      ? 'No notes found for "${_searchController.text}"'
                                      : 'Oops! Sepertinya kamu belum',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                if (_searchController.text.isEmpty)
                                  const Text(
                                    'memiliki catatan apapun',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                            ],
                          ),
                        )
                        : RefreshIndicator(
                            onRefresh: _loadUserNotes,
                            child: ListView.builder(
                              itemCount: _filteredNotes.length,
                              itemBuilder: (context, index) {
                                return NoteItem(note: _filteredNotes[index]);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
