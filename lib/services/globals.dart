// globals.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseURL = "http://192.168.1.8:8000/api/"; // Ganti sesuai IP lokalmu

String? token; // Ini nanti diisi setelah login

Map<String, String> get headers => {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  if (token != null) 'Authorization': 'Bearer $token',
};

Future<void> loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
  print("LOADED TOKEN: $token");
}

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(text),
      duration: const Duration(seconds: 1),
    ),
  );
}
