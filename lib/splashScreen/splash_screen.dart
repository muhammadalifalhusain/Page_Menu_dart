import 'package:flutter/material.dart';

import '../pages/login_page.dart'; 

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF944645), 
      body: Center(
        child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Image.asset(
      'assets/images/final_logo.png', 
      height: 150,
      width: 150,
    ),
    SizedBox(height: 20),
    Text(
      'Feeling Your Home',
      style: TextStyle(
        fontSize: 28, 
        color: const Color(0xFFF0EB8F), 
        fontWeight: FontWeight.bold, 
        fontStyle: FontStyle.italic, 
        letterSpacing: 1.2, 
        shadows: [
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
    ),
    SizedBox(height: 8), 
    Text(
      'with the beautiful creation of wood',
      style: TextStyle(
        fontSize: 20, 
        color: const Color(0xFFF0EB8F), 
        fontWeight: FontWeight.normal, 
        fontStyle: FontStyle.normal, 
        letterSpacing: 1.0, 
        shadows: [
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 2.0,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
    ),
  ],
),
      ),
    );
  }
}
