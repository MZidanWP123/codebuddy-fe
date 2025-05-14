import 'package:finalprojectapp/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Pastikan path ini sesuai dengan struktur project kamu

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late SharedPreferences prefs;
  String? name;
  String? email;
  String? token;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      token = prefs.getString('token');
      isLoading = false;
    });
  }

  void logout() async {
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${name ?? "-"}'),
                  const SizedBox(height: 8),
                  Text('Email: ${email ?? "-"}'),
                  const SizedBox(height: 8),
                  Text('Token: ${token ?? "-"}'),
                  const SizedBox(height: 32),
                  Center(
                    child: MaterialButton(
                      onPressed: logout,
                      color: Colors.red,
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      child: const Text('Logout'),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
