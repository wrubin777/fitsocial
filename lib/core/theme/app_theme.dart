import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF); // Purple with a modern touch
  static const Color accentColor = Color(0xFF00FFCC);  // Neon teal for that "good lighting" gym vibe
  static const Color darkBackground = Color(0xFF121212); // Deep dark background
  static const Color darkSurface = Color(0xFF1E1E1E);  // Slightly lighter dark for cards
  static const Color darkGrey = Color(0xFF333333);     // Dark grey for UI elements
  static const Color lightGrey = Color(0xFFAAAAAA);    // Light grey for text
  static const Color successColor = Color(0xFF4CAF50); // Green for success
  static const Color errorColor = Color(0xFFF44336);   // Red for errors
  static const Color warningColor = Color(0xFFFF9800); // Orange for warnings
  static const Color highIntensityColor = Color(0xFFFF3D00); // Intense red for high intensity workouts
  static const Color mediumIntensityColor = Color(0xFFFFC107); // Amber for medium intensity workouts
  static const Color lowIntensityColor = Color(0xFF4CAF50); // Green for low intensity workouts
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00FFCC), Color(0xFF00CCFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text styles using custom fonts
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.white,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 12,
      color: lightGrey,
    ),
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );
  
  // Alternative font for headers and special elements
  static TextStyle get headerAltStyle => GoogleFonts.bebasNeue(
    fontSize: 28, 
    letterSpacing: 1.2, 
    color: Colors.white,
  );
  
  // Theme data
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: darkSurface,
      background: darkBackground,
      error: errorColor,
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: accentColor,
      unselectedItemColor: lightGrey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: darkBackground,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: lightGrey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        textStyle: textTheme.labelLarge?.copyWith(color: accentColor),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkGrey,
      labelStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: darkGrey,
      thickness: 1,
    ),
  );
}
