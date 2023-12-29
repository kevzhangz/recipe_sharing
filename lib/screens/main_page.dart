import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/screens/post_recipe.dart';
import 'package:recipe_sharing/screens/search.dart';
import 'home.dart';
import 'profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool _isLocked = false;

  void _onItemTapped(int index) {
    if (!_isLocked) {
      setState(() {
        _selectedIndex = index;
        _isLocked = true;
      });

      _pageController.jumpToPage(index);

      // Unlock after a certain duration (e.g., 2 seconds)
      Timer(const Duration(milliseconds: 150), () {
        setState(() {
          _isLocked = false;
        });
      });
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Search(),
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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _widgetOptions,
      ),
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