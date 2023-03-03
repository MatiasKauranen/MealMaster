import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealmaster/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
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
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                  errorMessage = '';
                });
                try {
                  final userCredential = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (userCredential != null) {
                    User? user = userCredential.user;
                    if (user != null) {
                      print('Logged in as ${user.email}');
                      Navigator.pushNamed(context, HomeScreen.id);
                    }
                  }
                  setState(() {
                    showSpinner = false;
                  });
                } on FirebaseAuthException catch (e) {
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
                  setState(() {
                    showSpinner = false;
                    errorMessage = 'Could not log in. Please try again later.';
                  });
                }
              },
              child: Text('Log In'),
            ),
            SizedBox(height: 8.0),
            if (showSpinner)
              Center(
                child: CircularProgressIndicator(),
              ),
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
