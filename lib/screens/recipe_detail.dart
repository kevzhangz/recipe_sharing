import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/custom_dialog.dart';
import 'package:recipe_sharing/widget/custom_radio_button.dart';

class RecipeDetail extends StatefulWidget {
  RecipeDetail({super.key, required this.recipe});

  dynamic recipe;

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  String _selected = 'Descriptions';
  String? _shownInfo;
  String? rating;
  bool? isSaved;

  @override
  void initState() {
    super.initState();
    rating = widget.recipe['rating'].toString();
    isSaved = widget.recipe['isSaved'];
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  _onItemTapped(type) {
    if(mounted){
      setState(() {
        _selected = type;
        _shownInfo = widget.recipe[type.toString().toLowerCase()];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final img = base64Decode(widget.recipe['image']);

    return Scaffold(
      backgroundColor: HexColor("#FF9E0C"),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 15),
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepPurple.shade100
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_outlined),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        widget.recipe['isCreated'] ?
                        Padding(
                          padding: const EdgeInsets.only(top: 40, right: 15),
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepPurple.shade100
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.settings_outlined),
                              onPressed: () => showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                context: context, 
                                builder: (context) => RecipeSetting(recipe: widget.recipe),
                              )
                            ),
                          ),
                        ) 
                        : 
                        const Text(""),
                      ]
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 115,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 110,
                        backgroundColor: const Color.fromARGB(255, 119, 76, 11),
                        backgroundImage: MemoryImage(img)
                      )
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                        child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 8, 30, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.recipe['title'], 
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)
                                      )
                                    ),
                                    IconButton(
                                      onPressed: _handleSave,
                                      iconSize: 32,
                                      icon: isSaved == true ? const Icon(Icons.star) : const Icon(Icons.star_outline),
                                      color: HexColor("#FF9E0C")
                                    )
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Created by ${widget.recipe['posted_by']['name']}" 
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "⭐ ${rating != '0' ? rating : 'Unrated'}"
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.recipe['category'].join(' ')
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(child: CustomRadioButton(label: 'Descriptions', isSelected: _selected == 'Descriptions', onPressed: _onItemTapped)),
                                    const SizedBox(width: 10),
                                    Expanded(child: CustomRadioButton(label: 'Ingredients', isSelected: _selected == 'Ingredients', onPressed: _onItemTapped)),
                                    const SizedBox(width: 10),
                                    Expanded(child: CustomRadioButton(label: 'Instructions', isSelected: _selected == 'Instructions', onPressed: _onItemTapped)),
                                  ]
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _selected,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  )
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _shownInfo ?? widget.recipe['descriptions']
                                ),
                                const SizedBox(height: 30),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () => 
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context) => RatingDialog(onPressed: _handleRating,
                                    )
                                  ),
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(const Size.fromHeight(5)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            HexColor("#FF9E0C")),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'Rate This',
                                      style: TextStyle(fontWeight: FontWeight.bold)
                                    )
                                  ),
                                ),
                              ]
                            )
                          )
                        )
                      )
                    )
                  ]
                )
              )
            )
          );
        }
      )
    );
  }

  _handleRating(rate) async {
    Navigator.pop(context);
    var data = {
      'rating': rate,
    };

    var snackBar = const SnackBar(
      content: Text('Successfully Rated'),
    );

    dynamic res = await Network().rateRecipe(widget.recipe['recipe_id'], data);
    dynamic body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (context.mounted) {
        setState(() {
          rating = body['rating'].toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (body['error'] != null) {
      if (mounted) {
        var snackBar = SnackBar(
          content: Text(body['error']),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

    _handleSave() async {
    dynamic res = await Network().saveRecipe(widget.recipe['recipe_id']);
    dynamic body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (mounted) {
        setState(() {
          isSaved = !isSaved!;
        });

        String action = 'Saved';
        if(isSaved == false){
          action = 'Unsaved';
        }

        var snackBar = SnackBar(
          content: Text('Recipe $action'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (body['error'] != null) {
      if (mounted) {
        var snackBar = SnackBar(
          content: Text(body['error']),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}

class RecipeSetting extends StatefulWidget {
  RecipeSetting({Key? key, required this.recipe}) : super(key: key);

  dynamic recipe;

  @override
  State<RecipeSetting> createState() => _RecipeSettingState();
}

class _RecipeSettingState extends State<RecipeSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: 230,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Recipe Settings", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/update_recipe', arguments: widget.recipe),
              child: Align(
                alignment: Alignment.centerLeft,
                child : Text("Update Recipe", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: HexColor("#242424")))
              )
            ),
            TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmDialog(onConfirm: deleteRecipe),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child : Text("Remove Recipe", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: Colors.red))
              )
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteRecipe() async {
    var res = await Network().deleteRecipe(widget.recipe['recipe_id']);
    var body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if(mounted){
        Navigator.pushReplacementNamed(context, '/home');

        var snackBar = SnackBar(
          content: Text(body['messages']),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}