import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalprojectapp/services/globals.dart';

class CourseServices {
  // Get all courses
  static Future<http.Response> getAllCourses() async {
    var url = Uri.parse('$baseURL/courses');
    http.Response response = await http.get(url, headers: headers);
    return response;
  }

  // Search course by title
  static Future<http.Response> searchCourseByTitle(String title) async {
    var url = Uri.parse('$baseURL/courses/search?title=$title');
    http.Response response = await http.get(url, headers: headers);
    return response;
  }

  // Create a new course
  static Future<http.Response> createCourse({
    required String title,
    required String url,
    String? description,
    String? thumbnail,
    required String createdBy,
  }) async {
    Map<String, dynamic> data = {
      "title": title,
      "url": url,
      "created_by": createdBy,
    };

    if (description != null) data["description"] = description;
    if (thumbnail != null) data["thumbnail"] = thumbnail;

    var body = json.encode(data);
    var endpoint = Uri.parse('$baseURL/courses/create');
    http.Response response = await http.post(endpoint, headers: headers, body: body);
    return response;
  }

  // Update existing course
  static Future<http.Response> updateCourse({
    required int id,
    String? title,
    String? url,
    String? description,
    String? thumbnail,
    String? createdBy,
  }) async {
    Map<String, dynamic> data = {};

    if (title != null) data["title"] = title;
    if (url != null) data["url"] = url;
    if (description != null) data["description"] = description;
    if (thumbnail != null) data["thumbnail"] = thumbnail;
    if (createdBy != null) data["created_by"] = createdBy;

    var body = json.encode(data);
    var endpoint = Uri.parse('$baseURL/courses/$id');
    http.Response response = await http.put(endpoint, headers: headers, body: body);
    return response;
  }

  // Delete a course by ID
  static Future<http.Response> deleteCourse(int id) async {
    var endpoint = Uri.parse('$baseURL/courses/$id');
    http.Response response = await http.delete(endpoint, headers: headers);
    return response;
  }
}
