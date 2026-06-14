import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/user_role.dart';
import '../../providers/auth_provider.dart';
import '../../services/settings_service.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {
  final TextEditingController passwordController =
      TextEditingController();

  UserRole selectedRole = UserRole.owner;

  void login() {
    final settings =
        SettingsService.getSettings();

    final ownerPassword =
        settings.password;

    const staffPassword = 'bg1234';

    bool isValid = false;

    if (selectedRole == UserRole.owner) {
      isValid =
          passwordController.text.trim() ==
              ownerPassword;
    } else {
      isValid =
          passwordController.text.trim() ==
              staffPassword;
    }

    if (isValid) {
      ref
          .read(authProvider.notifier)
          .login(selectedRole);

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
                  height: 30,
                ),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRole =
                                UserRole.owner;
                          });
                        },
                        child: Container(
                          padding:
                              const EdgeInsets
                                  .all(16),
                          decoration:
                              BoxDecoration(
                            color:
                                selectedRole ==
                                        UserRole
                                            .owner
                                    ? Colors.orange
                                    : Colors.grey
                                        .shade300,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons
                                    .admin_panel_settings,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'OWNER',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRole =
                                UserRole.staff;
                          });
                        },
                        child: Container(
                          padding:
                              const EdgeInsets
                                  .all(16),
                          decoration:
                              BoxDecoration(
                            color:
                                selectedRole ==
                                        UserRole
                                            .staff
                                    ? Colors.orange
                                    : Colors.grey
                                        .shade300,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.engineering,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'STAFF',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 24,
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
                      Text(
                        selectedRole ==
                                UserRole.owner
                            ? 'Owner Login'
                            : 'Staff Login',
                        style:
                            const TextStyle(
                          fontSize: 22,
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
                              Colors.grey,
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