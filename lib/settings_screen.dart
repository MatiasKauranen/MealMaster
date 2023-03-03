import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mealmaster/components/navbar.dart';
import 'package:mealmaster/favorites_screen.dart';
import 'package:mealmaster/home_screen.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Text(
                  'Legal',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16.0),
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
