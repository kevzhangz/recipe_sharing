import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/recipe_list.dart';
import 'package:recipe_sharing/widget/custom_search_bar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search> {
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
            collapsedHeight: 10,
            toolbarHeight: 10,
            backgroundColor: Colors.white,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: refreshData,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 16),
              child: Column(
                children: [
                  CustomSearchBar(),
                  RecipeList(recipes: recipes, isLoading: loadRecipe, count: 6),
                ]
              )
            ),
          )
        ]
      )
    );
  }

  Future refreshData() async {
    setState(() {
      loadRecipe = true;
    });
    _loadRecipe();
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
