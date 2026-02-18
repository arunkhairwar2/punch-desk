import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Color Palette ──
  static const Color _primaryDark = Color(0xFF0D1B2A);
  static const Color _surfaceDark = Color(0xFF1B2838);
  static const Color _cardDark = Color(0xFF243447);
  static const Color _accentTeal = Color(0xFF00BFA6);
  static const Color _accentBlue = Color(0xFF448AFF);
  static const Color _errorRed = Color(0xFFFF5252);
  static const Color _textPrimary = Color(0xFFE0E6ED);
  static const Color _textSecondary = Color(0xFF8899A6);

  static Color get accentTeal => _accentTeal;
  static Color get accentBlue => _accentBlue;
  static Color get errorRed => _errorRed;
  static Color get cardDark => _cardDark;
  static Color get textSecondary => _textSecondary;

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [_accentTeal, _accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [_primaryDark, Color(0xFF0A1628)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── ThemeData ──
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _primaryDark,
      primaryColor: _accentTeal,
      colorScheme: const ColorScheme.dark(
        primary: _accentTeal,
        secondary: _accentBlue,
        surface: _surfaceDark,
        error: _errorRed,
        onPrimary: Colors.white,
        onSurface: _textPrimary,
      ),
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: _textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: _textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: _textPrimary),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _textSecondary),
      ),
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentTeal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _accentTeal, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: const TextStyle(color: _textSecondary),
        prefixIconColor: _textSecondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: _textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
    );
  }
}
