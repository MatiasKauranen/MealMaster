import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'recipe_screen.dart';

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

  Future<void> _removeFavoriteRecipe(String recipe) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRecipes.remove(recipe);
      prefs.setStringList('favoriteRecipes', _favoriteRecipes);
    });
  }

  Future<void> _clearFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRecipes = [];
      prefs.remove('favoriteRecipes');
    });
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
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: _favoriteRecipes == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _favoriteRecipes.isEmpty
              ? Center(
                  child: Text('No favorite recipes'),
                )
              : ListView.builder(
                  itemCount: _favoriteRecipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final recipeName = _favoriteRecipes[index];
                    return Dismissible(
                      key: Key(recipeName),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                      ),
                      onDismissed: (direction) {
                        _removeFavoriteRecipe(recipeName);
                      },
                      child: ListTile(
                        title: Text(recipeName),
                        onTap: () async {
                          final recipe = await _getRecipe(recipeName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeScreen(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearFavoriteRecipes,
        child: Icon(Icons.delete),
        tooltip: 'Clear all favorites',
      ),
    );
  }
}
