import 'dart:convert';
import 'package:flutter/foundation.dart'; // untuk debugPrint
import 'package:http/http.dart' as http;
import 'package:finalprojectapp/services/globals.dart';
import 'package:finalprojectapp/models/course.dart';

class CourseServices {
  // Get all courses (raw http.Response)
  static Future<http.Response> getAllCourses() async {
    var url = Uri.parse('${baseURL}courses');
    http.Response response = await http.get(url, headers: headers);
    return response;
  }

  // Get all courses as List<Course>
  static Future<List<Course>> fetchAllCourses() async {
    final response = await getAllCourses();

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

  // Get course by ID - PERBAIKAN
  static Future<Course> getCourseById(int courseId) async {
    var url = Uri.parse('${baseURL}courses/$courseId');
    
    // Debug: Print URL yang akan dipanggil
    debugPrint('Fetching course from URL: $url');
    
    http.Response response = await http.get(url, headers: headers);
    
    // Debug: Print response
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return Course.fromJson(data);
    } else {
      throw Exception('Failed to load course with ID $courseId: ${response.statusCode} - ${response.body}');
    }
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
    required String createdBy,
    String level = "beginner",
  }) async {
    Map<String, dynamic> data = {
      "title": title,
      "url": url,
      "created_by": createdBy,
      "level": level,
    };

    if (description != null) data["description"] = description;

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
    String? createdBy,
    String? level,
  }) async {
    Map<String, dynamic> data = {};

    if (title != null) data["title"] = title;
    if (url != null) data["url"] = url;
    if (description != null) data["description"] = description;
    if (createdBy != null) data["created_by"] = createdBy;
    if (level != null) data["level"] = level;

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
