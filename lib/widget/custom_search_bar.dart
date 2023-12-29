import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomSearchBar extends StatefulWidget {
  CustomSearchBar({super.key, this.handleSearch, this.handleFilter});

  dynamic handleSearch;
  dynamic handleFilter;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: TextField(
            onChanged: widget.handleSearch,
            decoration: InputDecoration(
              hintText: "Search Recipes",
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.black,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#FF9E0C"))
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
            color: HexColor("#FF9E0C"),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.tune),
            onPressed: widget.handleFilter,
          ),
        ),
      ],
    );
  }
}