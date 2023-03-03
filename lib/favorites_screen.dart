import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'recipe_screen.dart';
import 'package:mealmaster/components/navbar.dart';
import 'home_screen.dart';
import 'package:mealmaster/settings_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const String id = 'favorites_screen';
  const FavoritesScreen({Key? key}) : super(key: key);
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<String> _favoriteRecipes;
  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRecipes = prefs.getStringList('favoriteRecipes') ?? [];
    });
  }

  Future<void> _removeFavoriteRecipe(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final recipeName = _favoriteRecipes[index];
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Recipe'),
          content: Text('Are you sure you want to remove "$recipeName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      setState(() {
        _favoriteRecipes.removeAt(index);
        prefs.setStringList('favoriteRecipes', _favoriteRecipes);
      });
    }
  }

  Future<dynamic> _getRecipe(String recipeName) async {
    final url =
        'https://www.themealdb.com/api/json/v1/1/search.php?s=${recipeName.replaceAll(' ', '%20')}';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return data['meals'][0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Text(
                'Favorite Recipes',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _favoriteRecipes.isEmpty
                  ? Center(
                      child: Text('No favorite recipes'),
                    )
                  : ListView.builder(
                      itemCount: _favoriteRecipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final recipeName = _favoriteRecipes[index];
                        return ListTile(
                          title: Text(recipeName),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeFavoriteRecipe(index);
                            },
                          ),
                          onTap: () async {
                            final recipe = await _getRecipe(recipeName);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeScreen(recipe: recipe),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          } else if (index == 2) {
            Navigator.pushNamed(context, SettingsScreen.id);
          }
        },
      ),
    );
  }
}
