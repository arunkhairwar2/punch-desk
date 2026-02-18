import '../models/user_model.dart';

class AuthService {
  /// Mock login — returns a hardcoded user for any non-empty credentials.
  User? login(String email, String password) {
    if (email.isEmpty || password.isEmpty) return null;

    return const User(
      id: 1,
      name: 'Arun Khairwar',
      email: 'arun@example.com',
      role: 'EMPLOYEE',
    );
  }
}
