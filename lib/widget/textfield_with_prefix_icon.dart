import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TextFieldWithPrefixIcon extends StatelessWidget {
  TextFieldWithPrefixIcon({super.key, required this.icon, required this.label, required this.controller});

  dynamic icon;
  dynamic label;
  dynamic controller;
  dynamic keyboardType;

  @override
  Widget build(BuildContext context) {
    if(label == 'Email'){
      keyboardType = TextInputType.emailAddress;
    } else {
      keyboardType = TextInputType.none;
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            icon,
            width: 20,
            height: 20,
            fit: BoxFit.fill,
          ),
        ),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor("#FF9E0C"))
        ),
        isDense: true,
      ),
      obscureText: label == 'Password',
      keyboardType: TextInputType.emailAddress,
    );
  }
}