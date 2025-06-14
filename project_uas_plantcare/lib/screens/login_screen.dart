import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_uas_plantcare/data/plant_data.dart';
import 'package:project_uas_plantcare/screens/favorite_screen.dart';
import 'package:project_uas_plantcare/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_plantcare/screens/detail_screen.dart';
import 'package:project_uas_plantcare/screens/profile_screen.dart';
import 'package:project_uas_plantcare/screens/main_screen.dart';
import 'package:project_uas_plantcare/screens/login_screen.dart';
import 'package:project_uas_plantcare/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? registeredUsername = prefs.getString('username');
    String? registeredPassword = prefs.getString('password');

    if (_usernameController.text == registeredUsername &&
        _passwordController.text == registeredPassword) {
      await prefs.setString('loginTime', DateTime.now().toIso8601String());
      await prefs.setString('loggedInUser', _usernameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text('Belum punya akun? Daftar di sini'),
            ),
          ],
        ),
      ),
    );
  }
}
