import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/screens/post_recipe.dart';
import 'home.dart';
import 'profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text("Search"),
    PostRecipe(),
    Profile(),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: HexColor("#FF9E0C"),
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      )
    );
  }
}