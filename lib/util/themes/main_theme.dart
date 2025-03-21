import 'package:flutter/material.dart';

// Light Theme (Elegant Blue)
final ThemeData lightColorTheme = ThemeData(
  hintColor: Colors.grey[500], 
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0077CC), // Elegant Blue
    onPrimary: Colors.white, // Text/icons on primary
    primaryContainer: Color(0xFFE3F2FD), // Softer blue
    onPrimaryContainer: Color(0xFF003366), // Deep blue for contrast
    secondary: Color(0xFF0055A4), // Slightly darker blue
    onSecondary: Colors.white,
    error: Color(0xFFE53935), // Softer red
    onError: Colors.white,
    surface: Color(0xFFF5F5F5), // Soft background
    onSurface: Colors.black,
    tertiaryContainer: Color(0xFFCCE0FF), // Light pastel blue
    onTertiaryContainer: Color(0xFF002244), // Deep navy
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    textStyle: const TextStyle(color: Colors.white),
    color: const Color(0xFF0055A4), 
    selectedColor: Colors.white, 
    disabledColor: Colors.grey, 
    fillColor: const Color(0xFF0077CC), 
    focusColor: Colors.blueAccent, 
    highlightColor: Colors.blueAccent, 
    hoverColor: Colors.blue[400], 
    splashColor: Colors.blue[200], 
    borderColor: const Color(0xFF0055A4),
    selectedBorderColor: const Color(0xFF004080),
    disabledBorderColor: Colors.grey,
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    borderWidth: 1.0,
  ),
  fontFamily: 'Inter',
  primaryColor: const Color(0xFF0077CC),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF0055A4),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
    errorStyle: TextStyle(color: Colors.red),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Color(0xFF0077CC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Color(0xFF004080)),
    ),
  ),
);

// Dark Theme (Sleek Navy)
final ThemeData darkColorTheme = ThemeData(
  hintColor: Colors.grey[400], 
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0055A4), // Dark Blue
    onPrimary: Colors.white, 
    primaryContainer: Color(0xFF002244), // Deep navy
    onPrimaryContainer: Color(0xFFE3F2FD), // Light blue text
    secondary: Color(0xFF0077CC), // Brighter blue
    onSecondary: Colors.white, 
    error: Color(0xFFD32F2F), // Softer error color
    onError: Colors.white,
    surface: Color(0xFF121212), // True dark mode background
    onSurface: Colors.white,
    tertiaryContainer: Color(0xFF204060), // Midnight blue
    onTertiaryContainer: Color(0xFFD0E2FF), // Light contrast
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    textStyle: const TextStyle(color: Colors.white),
    color: const Color(0xFF0077CC), 
    selectedColor: Colors.white,
    disabledColor: Colors.grey,
    fillColor: const Color(0xFF0055A4), 
    focusColor: Colors.blueAccent, 
    highlightColor: Colors.blueAccent, 
    hoverColor: Colors.blue[700], 
    splashColor: Colors.blue[500], 
    borderColor: const Color(0xFF0077CC),
    selectedBorderColor: const Color(0xFF004080),
    disabledBorderColor: Colors.grey,
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    borderWidth: 1.0,
  ),
  fontFamily: 'JetBrains Mono',
  primaryColor: const Color(0xFF0055A4),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF002244),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
    errorStyle: TextStyle(color: Colors.red),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Color(0xFF0077CC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Color(0xFF004080)),
    ),
  ),
);

void main() {
  runApp(
    MaterialApp(
      theme: lightColorTheme,
      darkTheme: darkColorTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('White & Blue Theme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Blue Button'),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter something...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
