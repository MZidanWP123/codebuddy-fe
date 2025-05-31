import 'dart:convert';
import 'package:finalprojectapp/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:finalprojectapp/models/notes.dart';

class NoteServices {
  static Future<List<Note>> getNotes({int? userId}) async {
    final url = Uri.parse(
      userId != null ? '${baseURL}notes?user_id=$userId' : '${baseURL}notes',
    );
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<List<Note>> searchNotesByTitle(String title) async {
    final url = Uri.parse('${baseURL}notes/search?title=$title');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search notes');
    }
  }

  static Future<bool> createNote({
    required int userId,
    required int courseId,
    required String content,
  }) async {
    final data = {
      "user_id": userId,
      "course_id": courseId,
      "note": content,
    };

    final response = await http.post(
      Uri.parse('${baseURL}notes/create'),
      headers: headers,
      body: json.encode(data),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("HEADERS: $headers");
    print("userid: $userId");


    return response.statusCode == 201;
  }

  static Future<bool> updateNote({
    required int id,
    String? content,
    String? noteTitle,
  }) async {
    final data = <String, dynamic>{};

    if (noteTitle != null) data['note_title'] = noteTitle;
    if (content != null) data['content'] = content;

    final response = await http.put(
      Uri.parse('${baseURL}notes/$id'),
      headers: headers,
      body: json.encode(data),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteNote(int id) async {
    final response = await http.delete(
      Uri.parse('${baseURL}notes/$id'),
      headers: headers,
    );

    return response.statusCode == 200;
  }
}
