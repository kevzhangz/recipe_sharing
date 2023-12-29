import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomTextField extends StatefulWidget {

  CustomTextField({super.key, this.icon, required this.label, required this.controller, this.minLines, this.maxLines, this.maxLength});

  dynamic icon;
  dynamic label;
  dynamic controller;
  dynamic keyboardType;
  dynamic minLines;
  dynamic maxLines;
  dynamic maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.label == 'Email'){
      widget.keyboardType = TextInputType.emailAddress;
    } else if(widget.maxLines != null){
      widget.keyboardType = TextInputType.multiline;
    } else {
      widget.keyboardType = TextInputType.text;
    }

    return TextField(
      obscureText: widget.label == 'Password' ? _obscured : false,
      keyboardType: widget.keyboardType,
      focusNode: textFieldFocusNode,
      controller: widget.controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? 1,
      inputFormatters: widget.maxLength != null ? [
        WordLimitingTextInputFormatter(widget.maxLength),
      ] : null,
      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            widget.icon,
            width: 20,
            height: 20,
            fit: BoxFit.fill,
          ),
        ) : null,
        suffixIcon: widget.label == 'Password' ? 
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
            child: GestureDetector(
              onTap: _toggleObscured,
              child: Icon(
                _obscured
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 24,
                color: HexColor("#FF9E0C")
              ),
            )
          ) : const Text(""),
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor("#FF9E0C"))
        ),
        isDense: true,
      ),
    );
  }
}

class WordLimitingTextInputFormatter extends TextInputFormatter {
  final int _maxWords;

  WordLimitingTextInputFormatter(this._maxWords);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue) {
    int currentWords = newValue.text.split(' ').length;
    if (currentWords > _maxWords) {
      return oldValue;
    }
    return newValue;
  }
}