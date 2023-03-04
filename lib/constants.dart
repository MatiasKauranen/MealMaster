// Define a constant variable to be used as decoration for text fields
import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
// Set a default hint text
  hintText: 'Enter a value',
// Set padding for the text field content
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
// Define the border for the text field
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
// Define the enabled border for the text field
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
// Define the focused border for the text field
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
