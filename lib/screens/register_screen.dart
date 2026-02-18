import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    // Mock registration — just show success and pop back to login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registration successful! Please sign in.'),
        backgroundColor: AppTheme.accentTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.of(context).pop();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final mobileRegex = RegExp(r'^\d{10}$');
    if (!mobileRegex.hasMatch(value)) return 'Enter a valid 10-digit number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Logo / Branding ──
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppTheme.accentTeal.withValues(alpha: 0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontSize: 32),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Join PunchDesk to track your attendance',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 36),

                      // ── Register Card ──
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Register',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 22),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fill in your details to get started',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 24),

                              // Name
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Full Name',
                                  prefixIcon:
                                      Icon(Icons.person_outline, size: 20),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                              const SizedBox(height: 14),

                              // Email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Email address',
                                  prefixIcon:
                                      Icon(Icons.email_outlined, size: 20),
                                ),
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 14),

                              // Mobile
                              TextFormField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Mobile number',
                                  prefixIcon:
                                      Icon(Icons.phone_outlined, size: 20),
                                ),
                                validator: _validateMobile,
                              ),
                              const SizedBox(height: 14),

                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: 14),

                              // Confirm Password
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  prefixIcon: const Icon(
                                      Icons.lock_reset_outlined,
                                      size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword),
                                  ),
                                ),
                                validator: _validateConfirmPassword,
                              ),
                              const SizedBox(height: 24),

                              // Register Button
                              SizedBox(
                                height: 54,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentTeal
                                            .withValues(alpha: 0.3),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _handleRegister,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text('Create Account'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Back to Login
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: AppTheme.accentTeal,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
