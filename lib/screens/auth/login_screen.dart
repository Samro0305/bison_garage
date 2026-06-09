import 'package:flutter/material.dart';

import '../../services/settings_service.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final TextEditingController
      passwordController =
      TextEditingController();

  void login() {
    final settings =
        SettingsService.getSettings();

    final savedPassword =
        settings.password;

    if (passwordController.text.trim() ==
        savedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Incorrect Password',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/bison_logo.png',
                  height: 160,
                ),

                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'BISON GARAGE',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  'Professional Garage Management System',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets
                          .all(20),
                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withValues(
                      alpha: 0.05,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style:
                            TextStyle(
                          fontSize:
                              22,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      const Text(
                        'Enter your password to continue',
                        style:
                            TextStyle(
                          color:
                              Colors
                                  .grey,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      TextField(
                        controller:
                            passwordController,
                        obscureText:
                            true,
                        decoration:
                            const InputDecoration(
                          prefixIcon:
                              Icon(
                            Icons
                                .lock_outline,
                          ),
                          labelText:
                              'Password',
                          border:
                              OutlineInputBorder(),
                        ),
                        onSubmitted:
                            (_) =>
                                login(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width: double
                            .infinity,
                        height: 55,
                        child:
                            ElevatedButton(
                          onPressed:
                              login,
                          child:
                              const Text(
                            'LOGIN',
                            style:
                                TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color:
                        Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}