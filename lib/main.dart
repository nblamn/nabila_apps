import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NabilaApps());
}

class NabilaApps extends StatelessWidget {
  const NabilaApps({super.key});

  @override
  Widget build(BuildContext context) {
    const obsidianBloom = Color(0xFF4C1413);
    const guavaGlow = Color(0xFFEA6B7E);
    const blossomVapor = Color(0xFFFFDBED);
    const softBackground = Color(0xFFFFF5F8);

    return MaterialApp(
      title: 'NABILA APPS',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: obsidianBloom,
          primary: obsidianBloom,
          secondary: guavaGlow,
          surface: Colors.white,
          error: Colors.redAccent,
        ),

        scaffoldBackgroundColor: softBackground,

        appBarTheme: const AppBarTheme(
          backgroundColor: obsidianBloom,
          foregroundColor: blossomVapor,
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: blossomVapor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: obsidianBloom,
          ),
          prefixIconColor: guavaGlow,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: blossomVapor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: blossomVapor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: guavaGlow,
              width: 1.8,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: guavaGlow,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: guavaGlow,
          unselectedItemColor: Colors.black45,
          type: BottomNavigationBarType.fixed,
        ),

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      home: const LoginScreen(),
    );
  }
}
