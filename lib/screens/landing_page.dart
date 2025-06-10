import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    print(
      "--- LandingPage build dipanggil ---",
    ); // DEBUG: Untuk melacak pemanggilan build method

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_j-go.png', // pastikan kamu punya file ini di folder assets
                height: 120,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                ),
                onPressed: () {
                  print(
                    "--- Tombol Register di LandingPage ditekan ---",
                  ); // DEBUG
                  // Pastikan Anda sudah memiliki rute '/register' di main.dart
                  // dan file screen register_screen.dart
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Ditambahkan agar teks terlihat jelas
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'OR',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                ),
                onPressed: () {
                  print("--- Tombol Login di LandingPage ditekan ---"); // DEBUG
                  // Pastikan Anda sudah memiliki rute '/login' di main.dart
                  // dan file screen login_screen.dart
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(
                      255,
                      252,
                      252,
                      252,
                    ), // Ditambahkan agar teks terlihat jelas
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
