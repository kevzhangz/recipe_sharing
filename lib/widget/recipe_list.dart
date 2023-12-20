import 'package:flutter/material.dart';
import 'recipe_card.dart';

class RecipeList extends StatefulWidget {
  RecipeList({super.key, this.recipes});

  dynamic recipes;

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  dynamic recipes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 200,
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.recipes == null ? 0 : widget.recipes.length,
        itemBuilder: (context, index){
          return GestureDetector(
            child: RecipeCard(recipe: widget.recipes[index]),
            onTap: () => Navigator.pushNamed(context, "/details")
          );
        }
    );
  }
}