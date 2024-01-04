import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE7E5FA)),
          borderRadius: BorderRadius.circular(20),
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.memory(
                base64Decode(widget.recipe['image'].toString()),
                width: 160,
                height: 144,
                fit: BoxFit.cover,
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 10),
            child: RichText(
              text: TextSpan(
                text: widget.recipe['title'].length > maxTitleLength ? "${widget.recipe['title'].substring(0, maxTitleLength)}..." : widget.recipe['title'],
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF242424),
                  fontWeight: FontWeight.w600,
                  fontSize: 14
                ),
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
                  constraints: const BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.fromLTRB(10,1.5,10,1.5),
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
                child: widget.recipe['isSaved'] != null && widget.recipe['isSaved'] == true ? SvgPicture.asset('assets/images/svg/star filled.svg', height: 16, width: 16) : SvgPicture.asset('assets/images/svg/star.svg', height: 16, width: 16),
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
        color: Color(0xFF242424).withOpacity(0.04),
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
        Skeleton(width: 160, height: 144),
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
