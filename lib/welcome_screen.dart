// Import necessary packages
import 'package:flutter/material.dart';
import 'package:mealmaster/register_screen.dart';
import 'package:mealmaster/login_screen.dart';

// Define the welcome screen stateless widget
class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

// Build the welcome screen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
// Display the app logo
            Image.asset(
              'assets/logo.png',
              height: 400,
              width: 300,
            ),
            SizedBox(height: 16.0),
// Display the app title
            TitleText(),
            SizedBox(height: 32.0),
// Display the register and login buttons
            RegisterLoginButtons(),
          ],
        ),
      ),
    );
  }
}

// Define the title text stateless widget
class TitleText extends StatelessWidget {
  const TitleText({Key? key}) : super(key: key);

// Build the title text widget
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to MealMaster!',
          style: TextStyle(fontSize: 24.0),
        ),
        SizedBox(height: 8.0),
        Text(
          'Your new recipe book',
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}

// Define the register and login buttons stateless widget
class RegisterLoginButtons extends StatelessWidget {
  const RegisterLoginButtons({Key? key}) : super(key: key);

// Build the register and login buttons widget
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
// Display the register button
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, RegisterScreen.id);
          },
          child: Text('Register'),
        ),
        SizedBox(height: 16.0),
        Text(
          'Already registered?',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
// Display the login button
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, LoginScreen.id);
          },
          child: Text('Login'),
        ),
      ],
    );
  }
}
