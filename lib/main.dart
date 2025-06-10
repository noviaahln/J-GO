import 'package:flutter/material.dart';
import 'package:j_go/screens/beranda.dart';
import 'package:j_go/screens/profil.dart';
import 'package:j_go/screens/landing_page.dart';
import 'package:j_go/screens/register.dart';
import 'package:j_go/screens/login.dart';
import 'package:j_go/themes/bottom_navbar.dart'; // Tempat BottomNavbar berada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo App',
      theme: ThemeData(primarySwatch: Colors.green),
      home:
          const LandingPage(), // Tetap menggunakan BottomNavbar sebagai tampilan awal
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/beranda': (context) => BerandaScreen(),
        '/profil': (context) => ProfilScreen(),
        '/home': (context) => const BottomNavbar(),
      },
    );
  }
}
