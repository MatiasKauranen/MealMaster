import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'recipe_screen.dart';
import 'package:mealmaster/components/navbar.dart';
import 'home_screen.dart';
import 'package:mealmaster/settings_screen.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FavoritesScreen extends StatefulWidget {
  static const String id = 'favorites_screen';
  const FavoritesScreen({Key? key}) : super(key: key);
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<String> _favoriteRecipes;
  final _recipientController = TextEditingController();

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

  Future<Map<String, dynamic>> _getRecipe(String recipeName) async {
  final url =
      'https://www.themealdb.com/api/json/v1/1/search.php?s=${recipeName.replaceAll(' ', '%20')}';
  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);
  final recipe = data['meals'][0];
  final imageUrl = recipe['strMealThumb'];
  final ingredients = [    recipe['strIngredient1'],
    recipe['strIngredient2'],
    recipe['strIngredient3'],
    recipe['strIngredient4'],
    recipe['strIngredient5'],
    recipe['strIngredient6'],
    recipe['strIngredient7'],
    recipe['strIngredient8'],
    recipe['strIngredient9'],
    recipe['strIngredient10'],
    recipe['strIngredient11'],
    recipe['strIngredient12'],
    recipe['strIngredient13'],
    recipe['strIngredient14'],
    recipe['strIngredient15'],
    recipe['strIngredient16'],
    recipe['strIngredient17'],
    recipe['strIngredient18'],
    recipe['strIngredient19'],
    recipe['strIngredient20'],
  ].where((ingredient) => ingredient != null && ingredient.isNotEmpty).toList();
  final instructions = recipe['strInstructions'];

  return {
    'imageUrl': imageUrl,
    'ingredients': ingredients,
    'instructions': instructions,
  };
}

Future<void> _sendRecipeByEmail(String recipeName) async {
  final subject = 'Recipe: $recipeName';
  final recipe = await _getRecipe(recipeName);
  final imageUrl = recipe['imageUrl'];
  final ingredients = recipe['ingredients'];
  final instructions = recipe['instructions'];
  final isHTML = true;

  // Get the meal ID to create the meal page link
  final mealId = recipe['idMeal'];
  final mealPageLink = 'https://www.themealdb.com/meal/$mealId';

  final recipient = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Send Recipe'),
        content: TextField(
          controller: _recipientController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Recipient',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(_recipientController.text),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
  if (recipient != null) {
    final imageBytes = await http.readBytes(Uri.parse(imageUrl));
    final base64Image = base64Encode(imageBytes);
    final imageHtml = '<img src="data:image/png;base64,$base64Image">';
    final email = Email(
      body: '''
        $imageHtml
        <h2>Ingredients</h2>
        <ul>
          ${ingredients.map((ingredient) => '<li>$ingredient</li>').join('\n')}
        </ul>
        <h2>Instructions</h2>
        <p>$instructions</p>
        <p><a href="$mealPageLink">View on MealDB</a></p>
      ''',
      subject: subject,
      recipients: [recipient],
      isHTML: isHTML,
    );
    await FlutterEmailSender.send(email);
  }
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _removeFavoriteRecipe(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.email),
                                onPressed: () {
                                  _sendRecipeByEmail(recipeName);
                                },
                              ),
                            ],
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
