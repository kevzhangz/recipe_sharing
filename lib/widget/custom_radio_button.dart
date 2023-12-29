import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomRadioButton extends StatefulWidget {
  CustomRadioButton({super.key, required this.label, required this.isSelected, required this.onPressed});

  dynamic label;
  dynamic onPressed;
  dynamic isSelected;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => widget.onPressed(widget.label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: widget.isSelected ? HexColor("#FF9E0C") : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, color: widget.isSelected ? Colors.white : Colors.black)
        )
      )
    );
  }
}