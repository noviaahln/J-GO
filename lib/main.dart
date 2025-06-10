import 'package:flutter/material.dart';
import 'package:j_go/screens/beranda.dart';
import 'package:j_go/screens/profil.dart';
import 'package:j_go/screens/lacakDriver.dart';
import 'package:j_go/themes/bottom_navbar.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BottomNavbar(), // halaman utama dengan bottom navbar
      routes: {
        '/beranda': (context) => BerandaScreen(),
        '/profil': (context) => ProfilScreen(),
        '/lacak': (context) => const LocationMapScreen(), // halaman full screen tanpa bottom navbar
      },
    );
  }
}
