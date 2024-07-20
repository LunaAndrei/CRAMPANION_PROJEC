import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash_image.png',
          fit: BoxFit.contain, // Adjusted to fit the image within the screen
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
