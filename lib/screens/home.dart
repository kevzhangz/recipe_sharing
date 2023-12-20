import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/recipe_list.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic name;
  dynamic recipes;
  int _selectedIndex = 0;

  void initState() {
    super.initState();
    _loadUserData();
    _loadRecipe();
  }

  _loadUserData() async {
    const storage = FlutterSecureStorage();
    var userString = await storage.read(key: 'user');

    if (userString != null) {
      var user = jsonDecode(userString);

      setState(() {
        name = user['name'].toString();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleSearch(String input){
    // _results.clear();
    // for (var str in myCoolStrings){
    //   if(str.toLowerCase().contains(input.toLowerCase())){
    //     setState(() {
    //       _results.add(str);
    //     });
    //   }
    // }
  }

  void _loadRecipe() async {
    var res = await Network().getRecipeList(limit: 4);
    var body = jsonDecode(res.body);
    if(mounted){
      setState(() {
        recipes = body['result'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 12),
              ),
              Text('$name,', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: "Practices Recipes,\neasier at ",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                  children: [
                    TextSpan(
                        text: "home 👨‍🍳",
                        style: TextStyle(color: HexColor("#FF9E0C")),
                    ),
                  ]
                )
              ),
              const SizedBox(height: 40),
              Row(
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              RecipeList(recipes: recipes),
              const SizedBox(height: 150),
              ElevatedButton(
                onPressed: logout,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(HexColor("#FF9E0C")),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold))
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void logout() async {
    var res = await Network().logout();
    if (res.statusCode == 200) {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
}
