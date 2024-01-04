import 'package:flutter/material.dart';
import 'recipe_card.dart';

class RecipeList extends StatefulWidget {
  RecipeList({super.key, required this.recipes, required this.isLoading, this.count});

  dynamic recipes;
  bool isLoading;
  dynamic count;

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  dynamic recipes;

  @override
  Widget build(BuildContext context) {
    if(!widget.isLoading){
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 245,
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.recipes == null ? 0 : widget.recipes.length,
        itemBuilder: (context, index){
          return GestureDetector(
            child: RecipeCard(recipe: widget.recipes[index]),
            onTap: () => Navigator.pushNamed(context, "/details", arguments: widget.recipes[index])
          );
        }
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 245,
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.count ?? 4,
      itemBuilder: (context, index){
        return GestureDetector(
          child: const RecipeCardSkelton(),
          onTap: () {}
        );
      }
    );
  }
}