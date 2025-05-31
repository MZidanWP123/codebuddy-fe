// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart';

class AuthServices {
  static Future<http.Response> register(
      String name, String email, String password) async {
    Map data = {
      "name": name,
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      token = jsonResponse['token']; // Ambil dan simpan token dari Laravel
      print("Token disimpan: $token");
      return jsonResponse;
    } else {
      print("Login gagal: ${response.body}");
      return null;
    }
  }
}
