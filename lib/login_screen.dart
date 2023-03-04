// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealmaster/home_screen.dart';

// Stateful widget for the Login Screen
class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// State class for the Login Screen widget
class _LoginScreenState extends State<LoginScreen> {
// Firebase authentication instance
  final _auth = FirebaseAuth.instance;

// Variables for user email, password and spinner visibility
  late String email;
  late String password;
  bool showSpinner = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
// Login Screen title
            Center(
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
// Textfield for user email input
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
            ),
            SizedBox(height: 16.0),
// Textfield for user password input
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(height: 16.0),
// Elevated button for user to log in
            ElevatedButton(
              onPressed: () async {
// Show spinner and clear error message
                setState(() {
                  showSpinner = true;
                  errorMessage = '';
                });
                try {
// Attempt to sign in user with email and password
                  final userCredential = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  {
// If successful, navigate to Home Screen
                    User? user = userCredential.user;
                    if (user != null) {
                      print('Logged in as ${user.email}');
                      Navigator.pushNamed(context, HomeScreen.id);
                    }
                  }
// Hide spinner
                  setState(() {
                    showSpinner = false;
                  });
                } on FirebaseAuthException catch (e) {
// Handle error if login attempt fails
                  setState(() {
                    showSpinner = false;
                    if (e.code == 'wrong-password') {
                      errorMessage = 'Incorrect password';
                    } else {
                      errorMessage =
                          'Could not log in. Please try again later.';
                    }
                  });
                } catch (e) {
// Handle other errors
                  setState(() {
                    showSpinner = false;
                    errorMessage = 'Could not log in. Please try again later.';
                  });
                }
              },
              child: Text('Log In'),
            ),
            SizedBox(height: 8.0),
// Show spinner while user logs in
            if (showSpinner)
              Center(
                child: CircularProgressIndicator(),
              ),
// Show error message if login attempt fails
            if (errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
