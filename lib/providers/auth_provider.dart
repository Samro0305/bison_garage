import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/user_role.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, UserRole?>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<UserRole?> {
  AuthNotifier() : super(null);

  void login(UserRole role) {
    state = role;
  }

  void logout() {
    state = null;
  }
}