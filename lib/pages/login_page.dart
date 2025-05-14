import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:finalprojectapp/services/auth_services.dart';
import 'package:finalprojectapp/services/globals.dart';
import 'package:finalprojectapp/widget/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalprojectapp/pages/account_page.dart';

//import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthServices.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      //print(response.body);
      if (response.statusCode == 200) {
        final prefs = 
        await SharedPreferences.getInstance();
        await prefs.setString('token', responseMap['token']); // sesuaikan key
        await prefs.setString('name', responseMap['user']['name'],); // sesuaikan juga
        await prefs.setString('email', responseMap['user']['email']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AccountPage(),
          ),
        );
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter your email'),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(height: 30),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
              onChanged: (value) {
                _password = value;
              },
            ),
            const SizedBox(height: 30),
            RoundedButton(
              btnText: 'LOG IN',
              onBtnPressed: () => loginPressed(),
            ),
          ],
        ),
      ),
    );
  }
}
