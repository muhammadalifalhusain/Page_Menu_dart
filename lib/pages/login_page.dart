import 'package:flutter/material.dart';
import '../pages/menu_page.dart';
import '../helpers/dabase_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF0EB8F),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _message;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Fungsi login untuk memverifikasi username dan password
  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Username and Password cannot be empty!';
      });
      return;
    }

    // Cek apakah ada user yang cocok di database
    final user = await _dbHelper.login(username, password);

    if (user != null) {
      // Jika berhasil login, navigasi ke MenuPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    } else {
      setState(() {
        _message = 'Invalid username or password!';
      });
    }
  }

  // Fungsi createUser untuk menyimpan username dan password
  Future<void> _createUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Please enter both username and password!';
      });
      return;
    }

    try {
      // Menyimpan user ke database
      await _dbHelper.createUser(username, password);
      setState(() {
        _message = 'User created successfully, please login!';
      });
    } catch (e) {
      setState(() {
        _message = 'Error creating user, try another username!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AlHusain Furniture',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF0EB8F),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF944645),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: const Color(0xFFF0EB8F), // Warna label
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF944645), // Warna background
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: const Color(0xFFF0EB8F), // Warna label
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF944645), // Warna background
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFF944645),
                  elevation: 5,
                ),
                child: Text('Login',
                    style: TextStyle(color: const Color(0xFFF0EB8F))),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _createUser,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFF944645), // Warna tombol
                  elevation: 5,
                ),
                child: Text('Daftar',
                    style: TextStyle(color: const Color(0xFFF0EB8F))),
              ),
              SizedBox(height: 20),
              if (_message != null)
                Text(
                  _message!,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
