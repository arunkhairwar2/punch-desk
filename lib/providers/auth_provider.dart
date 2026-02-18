import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Returns null on success, or an error message on failure.
  String? login(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Please enter both email and password';
    }

    final user = _authService.login(email, password);
    if (user == null) {
      return 'Invalid credentials';
    }

    _user = user;
    notifyListeners();
    return null;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
