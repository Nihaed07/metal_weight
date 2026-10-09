import 'package:flutter/material.dart';
import 'package:metal_weight/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2C3E50),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2C3E50),
          secondary: Color(0xFFE67E22),
          surface: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}