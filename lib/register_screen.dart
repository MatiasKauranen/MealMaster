// Import required libraries
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealmaster/home_screen.dart';

// RegisterScreen class, extends StatefulWidget
class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

// Override createState method, returns _RegisterScreenState object
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

// _RegisterScreenState class, extends State
class _RegisterScreenState extends State<RegisterScreen> {
// Initialize FirebaseAuth instance
  final _auth = FirebaseAuth.instance;

// Initialize required variables
  late String email;
  late String password;
  bool showSpinner = false;
  String errorMessage = '';

// Override build method, returns a Scaffold widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
// Email TextField widget
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            SizedBox(height: 16.0),
// Password TextField widget
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(height: 16.0),
// Register Button widget
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
// Create user with email and password
                  await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
// Navigate to HomeScreen
                  Navigator.pushNamed(context, HomeScreen.id);
                } on FirebaseAuthException catch (e) {
// Set error message if there is a FirebaseAuthException
                  setState(() {
                    showSpinner = false;
                    errorMessage = e.message!;
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Register'),
            ),
            SizedBox(height: 8.0),
// Show CircularProgressIndicator if showSpinner is true
            if (showSpinner)
              Center(
                child: CircularProgressIndicator(),
              ),
// Show error message if errorMessage is not empty
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
