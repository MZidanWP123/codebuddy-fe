import 'package:flutter/material.dart';
import 'package:finalprojectapp/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
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