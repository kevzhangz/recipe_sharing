import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/screens/login.dart';
import 'package:recipe_sharing/screens/signup.dart';
import 'package:recipe_sharing/screens/page_not_found.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpPage(),
      initialRoute: '/register',
      onGenerateRoute: routeList,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: HexColor("#FF9E0C"),
      )
    );
  }
}

Route<dynamic> routeList(RouteSettings routeSettings) {
  final args = routeSettings.arguments;
  final Route<dynamic> route;

  switch (routeSettings.name) {
    case '/register':
      route = MaterialPageRoute(
        builder: (context) => SignUpPage(),
      );
      break;
    case '/login':
      route = MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
      break;
    default:
      route = MaterialPageRoute(builder: (context) => const PageNotFound());
      break;
  }

  return route;
}