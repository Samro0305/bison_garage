import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          },
          child: const Text(
            'Enter BISON GARAGE',
          ),
        ),
      ),
    );
  }
}