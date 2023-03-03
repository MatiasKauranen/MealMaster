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
            Text(
              'Welcome to MealMaster!',
              style: TextStyle(fontSize: 24.0),
            ),
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
            Text(
              'Already registered?',
              style: TextStyle(fontSize: 16.0),
            ),
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
