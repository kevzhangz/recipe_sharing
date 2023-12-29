import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/recipe_list.dart';
import 'package:recipe_sharing/widget/custom_search_bar.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic name;
  dynamic recipes;
  late bool loadRecipe;

  void initState() {
    super.initState();
    loadRecipe = true;
    _loadUserData();
    _loadRecipe();
  }

  _loadUserData() async {
    const storage = FlutterSecureStorage();
    var userString = await storage.read(key: 'user');

    if (userString != null) {
      var user = jsonDecode(userString);

      setState(() {
        name = user['name'].toString();
      });
    }
  }

  void _handleSearch(String input){
    // _results.clear();
    // for (var str in myCoolStrings){
    //   if(str.toLowerCase().contains(input.toLowerCase())){
    //     setState(() {
    //       _results.add(str);
    //     });
    //   }
    // }
  }

  void _loadRecipe() async {
    var res = await Network().getRecipeList(limit: 4);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 12),
              ),
              Text('$name,', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: "Practices Recipes,\neasier at ",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                  children: [
                    TextSpan(
                        text: "home 👨‍🍳",
                        style: TextStyle(color: HexColor("#FF9E0C")),
                    ),
                  ]
                )
              ),
              const SizedBox(height: 40),
              CustomSearchBar(),
              RecipeList(recipes: recipes, isLoading: loadRecipe),
            ],
          ),
        ),
      )
    );
  }
}
