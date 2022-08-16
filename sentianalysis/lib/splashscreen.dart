import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'Home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Senti Analysis',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      loaderColor: Colors.black,
    );
  }
}
