import 'package:flutter/material.dart';
import 'package:mealmaster/welcome_screen.dart';
import 'package:mealmaster/home_screen.dart';
import 'package:mealmaster/login_screen.dart';
import 'package:mealmaster/register_screen.dart';
import 'package:mealmaster/recipe_screen.dart';
import 'package:mealmaster/favorites_screen.dart';
import 'package:mealmaster/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealMaster',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        RecipeScreen.id: (context) => RecipeScreen(recipe: ModalRoute.of(context)!.settings.arguments as dynamic),
        SettingsScreen.id: (context) => SettingsScreen(),
        FavoritesScreen.id: (context) => FavoritesScreen(),
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
