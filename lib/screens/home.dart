import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  dynamic name, recipes;
  late bool loadRecipe;

  @override
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

  void _loadRecipe({search, filter}) async {
    if(!loadRecipe){
      setState(() {
        loadRecipe = true;
      });
    }

    var res = await Network().getRecipeList(limit: 4, search: search ?? '', filter: filter ?? '');
    var body = jsonDecode(res.body);
    if(mounted){
      setState(() {
        recipes = body['result'];
        loadRecipe = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          const SliverAppBar(
            collapsedHeight: 20,
            toolbarHeight: 20,
            backgroundColor: Colors.white,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: refreshData,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  CustomSearchBar(search: _loadRecipe),
                  RecipeList(recipes: recipes, isLoading: loadRecipe),
                ]
              )
            )
          )
        ],
      ),
    );
  }

  Future refreshData() async {
    _loadRecipe();
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
