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
  final maxTitleLength = 16;

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
            padding: const EdgeInsets.only(left: 8, top: 10),
            child: RichText(
              text: TextSpan(
                text: widget.recipe['title'].length > maxTitleLength ? "${widget.recipe['title'].substring(0, maxTitleLength)}..." : widget.recipe['title'],
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                children: [
                  TextSpan(
                      text: "\n${widget.recipe['category'][0]}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ]
              )
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 90),
                  padding: const EdgeInsets.fromLTRB(10,3,10,3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor("#FF9E0C")
                  ),
                  child: Text(
                      "⭐ ${widget.recipe['rating'] != 0 ? widget.recipe['rating'].toString() : 'Unrated'}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 10),
                child: Icon(
                  widget.recipe['isSaved'] != null && widget.recipe['isSaved'] == true ? Icons.star : Icons.star_outline,
                  color: HexColor("#FF9E0C")
                )
              )
            ],
          )
        ]
      )
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context){
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(16))
      ),
    );
  }
}

class RecipeCardSkelton extends StatelessWidget {
  const RecipeCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton(width: 160, height: 100),
        SizedBox(height: 10),
        Skeleton(width: 130, height: 15),
        SizedBox(height: 5),
        Skeleton(width: 80, height: 15),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Skeleton(width: 85, height: 15),
            Padding(padding: EdgeInsets.only(right: 10), child: Skeleton(width: 35, height: 15))
          ],
        )
      ],
    );
  }
}
