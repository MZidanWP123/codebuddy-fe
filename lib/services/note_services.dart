import 'dart:convert';
import 'package:finalprojectapp/services/globals.dart';
import 'package:http/http.dart' as http;

class NoteServices {
  // Get all notes or notes by user_id
  static Future<http.Response> getNotes({int? userId}) async {
    var url = Uri.parse(
      userId != null
          ? '$baseURL/notes?user_id=$userId'
          : '$baseURL/notes',
    );

    http.Response response = await http.get(url, headers: headers);
    return response;
  }

  // Search notes by title
  static Future<http.Response> searchNotesByTitle(String title) async {
    var url = Uri.parse('$baseURL/notes/search?title=$title');
    http.Response response = await http.get(url, headers: headers);
    return response;
  }

  // Create a new note
  static Future<http.Response> createNote({
    required int userId,
    required int courseId,
    required String note,
  }) async {
    Map data = {
      "user_id": userId,
      "course_id": courseId,
      "note": note,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/notes/create');
    http.Response response = await http.post(url, headers: headers, body: body);
    return response;
  }

  // Update a note by ID
  static Future<http.Response> updateNote({
    required int id,
    String? noteTitle,
    String? note,
  }) async {
    Map<String, dynamic> data = {};

    if (noteTitle != null) data['note_title'] = noteTitle;
    if (note != null) data['note'] = note;

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/notes/$id');
    http.Response response = await http.put(url, headers: headers, body: body);
    return response;
  }

  // Delete a note by ID
  static Future<http.Response> deleteNote(int id) async {
    var url = Uri.parse('$baseURL/notes/$id');
    http.Response response = await http.delete(url, headers: headers);
    return response;
  }
}
