import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shoe_provider.dart';
import 'screens/home_page.dart';

// Import stub screens for completeness
import 'screens/add_edit_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a consistent primary color swatch
    const MaterialColor primaryBlue = MaterialColor(
      0xFF1E88E5, // Primary blue color
      <int, Color>{
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: Color(0xFF2196F3),
        600: Color(0xFF1E88E5), // Used as the main color
        700: Color(0xFF1976D2),
        800: Color(0xFF1565C0),
        900: Color(0xFF0D47A1),
      },
    );

    return ChangeNotifierProvider(
      create: (context) => ShoeProvider(),
      child: MaterialApp(
        title: 'Shoe E-commerce Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // --- New Theme Configuration ---
          primarySwatch: primaryBlue,
          primaryColor: primaryBlue.shade600,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          // AppBar Style
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, // Ensure text and icons are black
            iconTheme: IconThemeData(color: Colors.black),
          ),

          // Card Style
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Button Style
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        // ---------------------------------
        home: const HomePage(),
        routes: {'/add-edit': (ctx) => const AddEditPage()},
      ),
    );
  }
}
