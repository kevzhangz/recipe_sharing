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
                              onPressed: () => Navigator.pop(context),
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
                                const SizedBox(height: 25),
                                Text(
                                  widget.recipe['title'], 
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Created by ${widget.recipe['posted_by']['name']}" 
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "⭐ ${widget.recipe['rating'] != 0 ? widget.recipe['rating'].toString() : 'Unrated'}"
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

  _handleRating(rating) async {
    Navigator.pop(context);
    var data = {
      'rating': rating,
    };

    var snackBar = const SnackBar(
      content: Text('Successfully Rated'),
    );

    dynamic res = await Network().rateRecipe(widget.recipe['recipe_id'], data);
    dynamic body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
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