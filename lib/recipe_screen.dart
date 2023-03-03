import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeScreen extends StatefulWidget {
  static const String id = 'recipe_screen';

  final dynamic recipe;

  const RecipeScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isFavorite = false;
  List<String> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.recipe['idMeal']?.toString() ?? '') ?? false;
      _favoriteRecipes = prefs.getStringList('favoriteRecipes') ?? [];
    });
  }

  void _toggleFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String recipeName = widget.recipe['strMeal'] ?? '';
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        // Add recipe to favorites
        _favoriteRecipes.add(recipeName);
      } else {
        // Remove recipe from favorites
        _favoriteRecipes.remove(recipeName);
      }
      prefs.setStringList('favoriteRecipes', _favoriteRecipes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['strMeal'] ?? ''),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavoriteStatus,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
            widget.recipe['strMealThumb'] ?? 'https://via.placeholder.com/150',
            fit: BoxFit.cover,
          ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ingredients',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildIngredientsList(widget.recipe),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Instructions',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.recipe['strInstructions'] ?? '',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsList(dynamic recipe) {
    final List<Widget> list = [];

    for (int i = 1; i <= 20; i++) {
      if (recipe['strIngredient$i'] != null &&
          recipe['strIngredient$i'] != '') {
        list.add(Text(
          '- ${recipe['strMeasure$i']} ${recipe['strIngredient$i']}',
          style: TextStyle(fontSize: 16.0),
        ));
      }
    }

    return list;
  }
}
