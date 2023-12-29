import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/recipe_list.dart';
import 'package:recipe_sharing/widget/custom_search_bar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  dynamic recipes;
  late bool loadRecipe = true;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  void _loadRecipe() async {
    var res = await Network().getRecipeList();
    var body = jsonDecode(res.body);
    if(mounted){
      setState(() {
        recipes = body['result'];
        loadRecipe = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 16),
          child: Column(
            children: [
              const SizedBox(height: 30),
              CustomSearchBar(),
              RecipeList(recipes: recipes, isLoading: loadRecipe, count: 6),
            ]
          )
        )
      )
    );
  }
}
