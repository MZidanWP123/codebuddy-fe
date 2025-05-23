import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finalprojectapp/services/auth_services.dart';
import 'package:finalprojectapp/services/globals.dart';

import 'package:finalprojectapp/widget/rounded_button.dart';
//import 'home_page.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalprojectapp/pages/account_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterPage> {
  String _email = '';
  String _password = '';
  String _name = '';

  createAccountPressed() async {
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(_email);
    if (emailValid) {
      http.Response response = await AuthServices.register(
        _name,
        _email,
        _password,
      );
      Map responseMap = jsonDecode(response.body);
      //print(response.body);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', responseMap['user']['email']);
        await prefs.setString('token', responseMap['token']);
        await prefs.setString('name', responseMap['user']['name']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AccountPage(),
          ),
        );
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    } else {
      errorSnackBar(context, 'email not valid');
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
          'Registration',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(hintText: 'Name'),
              onChanged: (value) {
                _name = value;
              },
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: const InputDecoration(hintText: 'Email'),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(height: 30),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
              onChanged: (value) {
                _password = value;
              },
            ),
            const SizedBox(height: 40),
            RoundedButton(
              btnText: 'Create Account',
              onBtnPressed: () => createAccountPressed(),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                );
              },
              child: const Text(
                'already have an account',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
