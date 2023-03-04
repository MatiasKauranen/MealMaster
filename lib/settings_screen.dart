// Import necessary packages
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mealmaster/components/navbar.dart';
import 'package:mealmaster/favorites_screen.dart';
import 'package:mealmaster/home_screen.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

// Define a stateful widget for the settings screen
class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

// Define the state for the settings screen
class _SettingsScreenState extends State<SettingsScreen> {
// Build the settings screen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
// Display screen title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
// Display appearance options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16.0),
// Display dark mode switch
                ListTile(
                  title: Text('Dark mode'),
                  trailing: Switch(
                    value: AdaptiveTheme.of(context).mode ==
                        AdaptiveThemeMode.dark,
                    onChanged: (value) {
                      if (value) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                  ),
                ),
                SizedBox(height: 32.0),
              ],
            ),
          ),
// Display legal options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Legal',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16.0),
// Display button to privacy policy
                ElevatedButton(
                  child: Text('Privacy Policy'),
                  onPressed: () async {
                    const url = 'https://example.com/privacy-policy';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                SizedBox(height: 8.0),
// Display button to license
                ElevatedButton(
                  child: Text('License'),
                  onPressed: () async {
                    const url = 'https://example.com/license';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                SizedBox(height: 8.0),
// Display button to log out
                ElevatedButton(
                  child: Text('Log out'),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
// Display the bottom navigation bar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, FavoritesScreen.id);
          }
        },
      ),
    );
  }
}
