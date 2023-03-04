// Import necessary packages and screens
import 'package:flutter/material.dart';
import 'package:mealmaster/welcome_screen.dart';
import 'package:mealmaster/home_screen.dart';
import 'package:mealmaster/login_screen.dart';
import 'package:mealmaster/register_screen.dart';
import 'package:mealmaster/recipe_screen.dart';
import 'package:mealmaster/favorites_screen.dart';
import 'package:mealmaster/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

// Main function
void main() async {
// Ensure that Flutter is initialized and Firebase is ready
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
// Run the app
  runApp(MyApp());
}

// The main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// Wrap the app with AdaptiveTheme to enable dynamic light/dark theme switching
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      initial: AdaptiveThemeMode.light, // Set the initial theme mode to light
      builder: (theme, darkTheme) => MaterialApp(
        title: 'MealMaster',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute:
            WelcomeScreen.id, // Set the initial route to the welcome screen
        routes: {
// Define routes for each screen
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          RecipeScreen.id: (context) => RecipeScreen(
              recipe: ModalRoute.of(context)!.settings.arguments as dynamic),
          SettingsScreen.id: (context) => SettingsScreen(),
          FavoritesScreen.id: (context) => FavoritesScreen(),
        },
      ),
    );
  }
}
