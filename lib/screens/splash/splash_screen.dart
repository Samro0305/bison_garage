import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  int step = 0;

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(milliseconds: 700),
      () {
        if (mounted) {
          setState(() {
            step = 1;
          });
        }
      },
    );

    Timer(
      const Duration(milliseconds: 1400),
      () {
        if (mounted) {
          setState(() {
            step = 2;
          });
        }
      },
    );

    Timer(
      const Duration(milliseconds: 2100),
      () {
        if (mounted) {
          setState(() {
            step = 3;
          });
        }
      },
    );

    Timer(
      const Duration(seconds: 5),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
        );
      },
    );
  }

  Widget loadingText(
    String text,
    bool visible,
  ) {
    return AnimatedOpacity(
      duration:
          const Duration(milliseconds: 300),
      opacity: visible ? 1 : 0,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bison_logo.png',
              height: 220,
            ),

            const SizedBox(height: 20),

            const Text(
              'BISON GARAGE',
              style: TextStyle(
                fontSize: 34,
                fontWeight:
                    FontWeight.bold,
                color: Color(0xFF0A1025),
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Professional Garage Management System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Preparing Your Workspace...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            const SizedBox(height: 35),

            loadingText(
              '✓ Loading Settings',
              step >= 0,
            ),

            loadingText(
              '✓ Loading Invoices',
              step >= 1,
            ),

            loadingText(
              '✓ Loading Reports',
              step >= 2,
            ),

            loadingText(
              '✓ Starting Dashboard',
              step >= 3,
            ),

            const SizedBox(height: 35),

            const CircularProgressIndicator(
              color: Colors.orange,
            ),

            const SizedBox(height: 30),

            const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}