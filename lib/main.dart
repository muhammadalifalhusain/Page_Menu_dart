import 'package:flutter/material.dart';
import 'splashScreen/splash_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import './helpers/database_helper.dart';



void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
