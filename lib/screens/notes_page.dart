import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../widgets/notes_item.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

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
                    hintText: 'Search here',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.transparent),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D2A44),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(Icons.search, color: Colors.white, size: 20),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: sampleNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty_notes.png',
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Oops! Sepertinya kamu belum',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const Text(
                              'memiliki catatan apapun',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: sampleNotes.length,
                        itemBuilder: (context, index) {
                          return NoteItem(note: sampleNotes[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
