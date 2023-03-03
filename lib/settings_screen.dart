import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16.0),
            SwitchListTile(
              title: Text('Dark mode'),
              value: _isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                });
                if (_isDarkModeEnabled) {
                  // Enable dark mode
                  // You can set your app theme using:
                  // Theme.of(context).brightness = Brightness.dark;
                } else {
                  // Disable dark mode
                  // You can set your app theme using:
                  // Theme.of(context).brightness = Brightness.light;
                }
              },
            ),
            SizedBox(height: 32.0),
            Text(
              'Legal',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Privacy Policy'),
              onPressed: () async {
                const url = 'https://example.com/privacy-policy';
                if (await canLaunch(url)) {
                  await launch(url);
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
                if (await canLaunch(url)) {
                  await launch(url);
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
    );
  }
}
