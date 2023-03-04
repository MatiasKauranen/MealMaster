// Import required libraries
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mealmaster/recipe_screen.dart';
import 'package:mealmaster/favorites_screen.dart';
import 'package:mealmaster/settings_screen.dart';
import 'package:mealmaster/components/navbar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic>? _recipes;

// Method to search recipes based on a query
  Future<void> _searchRecipes(String query) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));

    if (response.statusCode == 200) {
      setState(() {
        _recipes = json.decode(response.body)['meals'];
      });
    } else {
      throw Exception('Failed to search recipes');
    }
  }

// Method to navigate to a random recipe
  Future<void> _navigateToRandomRecipe() async {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      final randomRecipe = json.decode(response.body)['meals'][0];
      Navigator.pushNamed(
        context,
        RecipeScreen.id,
        arguments: randomRecipe,
      );
    } else {
      throw Exception('Failed to fetch a random recipe');
    }
  }

  int _selectedIndex = 0;

// Method to handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return; // Do nothing if already on the selected screen
    }
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else if (_selectedIndex == 1) {
      Navigator.pushNamed(context, FavoritesScreen.id);
    } else if (_selectedIndex == 2) {
      Navigator.pushNamed(context, SettingsScreen.id);
    }
  }

// Override build method, returns a Scaffold widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  'What to eat today?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  onSubmitted: _searchRecipes,
                  decoration: InputDecoration(
                    hintText: 'Search meals, ingredient, or category',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
// Recipe list
          Expanded(
            child: _recipes == null
                ? Center(child: Text('Search for a meal!'))
                : _recipes!.isEmpty
                    ? Center(child: Text('No results found.'))
                    : ListView.builder(
                        itemCount: _recipes!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildRecipeCard(_recipes![index]);
                        },
                      ),
          ),
        ],
      ),
      // Floating action button for random recipe
      floatingActionButton: ElevatedButton(
        onPressed: _navigateToRandomRecipe,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Random meal',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

// Widget function to build recipe card
  Widget _buildRecipeCard(dynamic recipe) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RecipeScreen.id,
            arguments: recipe,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
// Display recipe image
            Image.network(
              recipe['strMealThumb'] ?? '',
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.0),
// Display recipe name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe['strMeal'] ?? '',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
