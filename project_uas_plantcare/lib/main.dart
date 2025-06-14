import 'package:project_uas_plantcare/data/plant_data.dart';
import 'package:project_uas_plantcare/screens/favorite_screen.dart';
import 'package:project_uas_plantcare/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_plantcare/screens/detail_screen.dart';
import 'package:project_uas_plantcare/screens/profile_screen.dart';
import 'package:project_uas_plantcare/screens/main_screen.dart';
import 'package:project_uas_plantcare/screens/login_screen.dart';
import 'package:project_uas_plantcare/screens/register_screen.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Care',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.deepPurple),
          titleTextStyle: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Colors.deepPurple,
          surface: Colors.deepPurple[50],
        ),
        useMaterial3: true

      ), // themaDATA 
      // home: DetailScreen(candi: candiList[0]),
      // home: ProfileScreen(),
      // home: SignInScreen(),
      // home: FavoriteScreen(),
      // home: SearchScreen(),
      // home: HomeScreen(),
      home: LoginScreen(),
      );
  }
}