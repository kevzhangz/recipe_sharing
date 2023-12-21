import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RecipeCard extends StatefulWidget {
  RecipeCard({super.key, required this.recipe});

  dynamic recipe;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.memory(
              base64Decode(widget.recipe['image'].toString()),
              width: 300,
              height: 100,
              fit: BoxFit.fill,
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: RichText(
              text: TextSpan(
                text: widget.recipe['title'],
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                children: [
                  TextSpan(
                      text: "\n${widget.recipe['category'].join(',')}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ]
              )
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 15),
              Container(
                constraints: const BoxConstraints(maxWidth: 70),
                padding: const EdgeInsets.fromLTRB(10,3,10,3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor("#FF9E0C")
                ),
                child: Text(
                    "⭐ ${widget.recipe['rating'] != 0 ? widget.recipe['rating'].toString() : 'New'}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                )
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star_outline),
                  color: HexColor("#FF9E0C")
                )
              ),
            ],
          )
        ]
      )
    );
  }
}