import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'Home.dart';

class Mysplash extends StatefulWidget {
  @override
  _MysplashState createState() => _MysplashState();
}

class _MysplashState extends State<Mysplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Classified',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.red,
        ),
      ),
      image: Image.asset("assets/cat.png"),
      gradientBackground: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.004, 1],
          colors: [Color(0xFFa8e063), Color(0xFF56ab2f)]),
      photoSize: 50,
      loaderColor: Colors.white,
    );
  }
}
