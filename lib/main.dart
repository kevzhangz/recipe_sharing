import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipe_sharing/screens/login.dart';
import 'package:recipe_sharing/screens/main_page.dart';
import 'package:recipe_sharing/screens/signup.dart';
import 'package:recipe_sharing/screens/page_not_found.dart';
import 'package:recipe_sharing/widget/recipe_detail.dart';
import 'package:recipe_sharing/widget/recipe_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const CheckAuth(),
        onGenerateRoute: routeList,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: HexColor("#FF9E0C"),
        ));
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  static const storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.read(key:'token'),
      builder: (BuildContext context, AsyncSnapshot prefs) {
        switch (prefs.connectionState) {
          case ConnectionState.done:
            if (prefs.data != null) {
              return const MainPage();
            } else {
              return const LoginPage();
            }
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      }
    );
  }
}

Route<dynamic> routeList(RouteSettings routeSettings) {
  final args = routeSettings.arguments;
  final Route<dynamic> route;

  switch (routeSettings.name) {
    case '/register':
      route = MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
      break;
    case '/login':
      route = MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
      break;
    case '/home':
      route = MaterialPageRoute(
        builder: (context) => const MainPage(),
      );
      break;
    case '/details':
      route = MaterialPageRoute(
        builder: (context) => RecipeDetail(recipe: args),
      );
      break;
    default:
      route = MaterialPageRoute(builder: (context) => const PageNotFound());
      break;
  }

  return route;
}