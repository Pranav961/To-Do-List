import 'package:flutter/material.dart';
import 'package:todo/splash_screen.dart';

void main() async {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: "Poppins"),
    home: const SplashScreen(),
    // home: const SplashScreen(),
  ));
}
