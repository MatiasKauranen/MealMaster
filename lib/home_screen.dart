import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mealmaster/recipe_screen.dart';
import 'package:mealmaster/favorites_screen.dart';
import 'package:mealmaster/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic>? _recipes;

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

  Future<void> _navigateToRandomRecipe() async {
  final response =
      await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

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
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pop(context);
    } else if (_selectedIndex == 1) {
      Navigator.pushNamed(context, FavoritesScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What to eat today?'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _searchRecipes,
              decoration: InputDecoration(
                hintText: 'Search meals by name, ingredient, or category',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

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
            Image.network(
              recipe['strMealThumb'] ?? '',
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe['strMeal'] ?? '',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getRandomIndex(int maxIndex) {
    final random = Random();
    return random.nextInt(maxIndex);
  }
}
