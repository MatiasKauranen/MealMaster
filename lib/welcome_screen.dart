import 'package:flutter/material.dart';
import 'package:mealmaster/register_screen.dart';
import 'package:mealmaster/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 400,
              width: 300,
            ),
            SizedBox(height: 0.0),
            Text(
              'Welcome to MealMaster!',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Your new recipe book',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.id);
              },
              child: Text('Register'),
            ),
            SizedBox(height: 32.0),
            Text(
              'Already registered?',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
