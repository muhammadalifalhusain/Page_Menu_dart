import 'package:flutter/material.dart';
import 'splashScreen/splash_screen.dart';
import 'pages/menu_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test app',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        ),
      home: SplashScreen(), // Ganti halaman utama dengan SplashScreen
    );
  }
}
