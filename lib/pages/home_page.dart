import 'package:flutter/material.dart';
import 'package:finalprojectapp/widget/rounded_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // RoundedButton(
            //     btnText: 'LOG OUT',
            //     onBtnPressed: () => loginPressed(),
            //   )
          ],
        ),
      ), 
    ); 
  }
}