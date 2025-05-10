import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define your orange color palette
  static const Color primaryOrange = Color.fromARGB(255, 241, 140, 8);
  static const Color darkOrange = Color(0xFFE65100); // Darker shade
  static const Color lightOrange = Color(0xFFFF9E40); // Lighter shade
  static const Color accentOrange = Color(0xFFFFAB40); // Accent shade

  static TextTheme lightTextTheme = TextTheme(
    // ... keep your existing text theme ...
  );

  static TextTheme darkTextTheme = TextTheme(
    // ... keep your existing dark text theme ...
  );

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryOrange,
      primaryContainer: darkOrange,
      secondary: accentOrange,
      secondaryContainer: lightOrange,
      surface: Colors.white,
      background: Colors.grey[200],
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    brightness: Brightness.light,
    primaryColor: primaryOrange,
    primaryColorLight: lightOrange,
    primaryColorDark: darkOrange,
    textTheme: lightTextTheme,

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      labelStyle: GoogleFonts.poppins(),
      hintStyle: GoogleFonts.poppins(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryOrange),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryOrange;
        }
        return Colors.grey;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryOrange;
        }
        return Colors.grey;
      }),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: primaryOrange,
      primaryContainer: darkOrange,
      secondary: accentOrange,
      secondaryContainer: lightOrange,
      surface: Colors.grey[850]!,
      background: Colors.grey[900]!,
      error: Colors.red[700]!,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    brightness: Brightness.dark,
    primaryColor: primaryOrange,
    primaryColorLight: lightOrange,
    primaryColorDark: darkOrange,
    textTheme: darkTextTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.grey[900],
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      labelStyle: GoogleFonts.poppins(color: Colors.white70),
      hintStyle: GoogleFonts.poppins(color: Colors.white60),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryOrange),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryOrange;
        }
        return Colors.grey;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryOrange;
        }
        return Colors.grey;
      }),
    ),
  );
}
