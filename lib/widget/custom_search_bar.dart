import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/helpers/helpers.dart';
import 'package:recipe_sharing/widget/category_selection.dart';

class CustomSearchBar extends StatefulWidget {
  CustomSearchBar({super.key, this.search});

  dynamic search;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  dynamic query = '';
  List selectedCategories = [];
  final _debouncer = Debouncer(milliseconds: 1000);

  void _handleSearch(String input) async {
    setState(() {
      query = input;
    });
    if(input.length >= 3){
      _debouncer.run(() => widget.search(search: query, filter: selectedCategories.join(',')));
    }
  }

  void _handleFilter(categories) async {
    setState(() {
      selectedCategories = categories;
    });
    widget.search(search: query, filter: selectedCategories.join(','));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: TextField(
            onChanged: _handleSearch,
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
            onPressed: () => showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              context: context, 
              builder: (context) => CategorySelection(selectedCategories: selectedCategories, onApply: _handleFilter)
            ),
          ),
        ),
      ],
    );
  }
}