import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CategorySelection extends StatefulWidget {
  CategorySelection({super.key, required this.selectedCategories, required this.onApply});

  dynamic selectedCategories;
  dynamic onApply;

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  final List<String> categories = ['🍔 Fast food', '🍰 Desert', '🍝 Pasta', '🦞 Sea Food', '🌶️ Spicy', '🍹Beverage', '🥗 Vegetarian', '🐄 Dairy Free']; // Your categories

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      height: 290,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Category", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            Wrap(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OutlinedButton(
                    onPressed: () => _toggleCategory(category),
                    style: ButtonStyle(
                        backgroundColor:
                          MaterialStateProperty.all<Color>(widget.selectedCategories.contains(category) ? HexColor("#FF9E0C") : Colors.white),
                    ),
                    child: Text(category, style: TextStyle(color: widget.selectedCategories.contains(category) ? Colors.white : Color(0xFF242424))),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.onApply(widget.selectedCategories),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(HexColor("#FF9E0C")),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Apply',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)
                      )
                    ),
                  ), 
                ),
                const SizedBox(width: 5),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.w600, color:Color(0xFF242424))
                    )
                  ),
                )
              ]
            )
          ]
        )
      )
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (widget.selectedCategories.contains(category)) {
        widget.selectedCategories.remove(category);
      } else {
        widget.selectedCategories.add(category);
      }
    });
  }
}


class CategoryButton extends StatefulWidget {
  CategoryButton({super.key, this.selectedCategories, this.onApply});

  dynamic selectedCategories;
  dynamic onApply;

 @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.selectedCategories.isNotEmpty ? List.generate(widget.selectedCategories.length, (index){
        return Padding(
          padding: EdgeInsets.only(right: 5),
          child: OutlinedButton(
            onPressed: () => showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              context: context, 
              builder: (context) => CategorySelection(selectedCategories: widget.selectedCategories, onApply: widget.onApply)
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                widget.selectedCategories[index],
                style: const TextStyle(fontWeight: FontWeight.w600, color:Color(0xFF242424))
              )
            ),
          )
        );
      })
      : 
      [
        OutlinedButton(
          onPressed: () => showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context, 
            builder: (context) => CategorySelection(selectedCategories: widget.selectedCategories, onApply: widget.onApply)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(3),
            child: Text(
              "Pick a category",
              style: TextStyle(fontWeight: FontWeight.w600, color:Color(0xFF242424))
            )
          ),
        ),
      ],
    );
  }
}