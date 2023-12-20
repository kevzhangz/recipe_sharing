import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PostButton extends StatefulWidget {
  PostButton({super.key, required this.label, required this.isSelected, required this.onPressed});

  dynamic label;
  dynamic onPressed;
  dynamic isSelected;

  @override
  State<PostButton> createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => widget.onPressed(widget.label),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(widget.isSelected ? HexColor("#FF9E0C") : Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, color: widget.isSelected ? Colors.white : Colors.black)
        )
      ),
    );
  }
}