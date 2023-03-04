// Import necessary packages
import 'package:flutter/material.dart';

// Define a custom bottom navigation bar widget
class CustomBottomNavigationBar extends StatelessWidget {
// Define variables to keep track of selected index and onItemTapped function
  final int selectedIndex;
  final Function(int) onItemTapped;

// Construct the widget
  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

// Build the bottom navigation bar widget
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
// Define the items to be displayed on the bottom navigation bar
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
// Set the current selected index and selected item color
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
// Make the unselected labels transparent
      unselectedLabelStyle: TextStyle(color: Colors.transparent),
// Define the onTap function
      onTap: onItemTapped,
    );
  }
}
