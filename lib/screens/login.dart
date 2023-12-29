import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/gestures.dart';

import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: HexColor("#FF9E0C"),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30, top: 25),
                      child: Image.asset("assets/images/chef.png", height: 300, width: 300),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                        child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 8, 30, 16),
                            child: Column(
                              crossAxisAlignment:CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 40),
                                const Text('Login',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                const SizedBox(height: 20),
                                RichText(
                                  text: const TextSpan(
                                    text: 'Enter your ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14),
                                    children: [
                                      TextSpan(
                                          text: 'Email ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: 'and '),
                                      TextSpan(
                                          text: 'Password',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ]
                                  )
                                ),
                                const SizedBox(height: 35),
                                CustomTextField(
                                    icon: 'assets/images/mail.png',
                                    label: 'Email',
                                    controller: _emailController
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                    icon: 'assets/images/password.png',
                                    label: 'Password',
                                    controller: _passwordController
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            HexColor("#FF9E0C")),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      _isLoading
                                          ? 'Processing...'
                                          : 'Login',
                                      style: const TextStyle(fontWeight: FontWeight.bold)
                                    )
                                  ),
                                ),
                                const SizedBox(height: 15),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14),
                                    children: [
                                      TextSpan(
                                          text: 'Sign up',
                                          style: const TextStyle(
                                              fontWeight: FontWeight
                                                  .bold),
                                          recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = () => Navigator.pushReplacementNamed(context,'/register')
                                      ),
                                    ]
                                  )
                                ),
                              ]
                            )
                          ),
                        )
                      )
                    )
                  ],
                )
              ),
            )
          );
        }
      )
    );
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    var data = {'email': email, 'password': password};

    dynamic res = await Network().auth(data);
    dynamic body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: json.encode(body['token']));
      await storage.write(key: 'user', value: json.encode(body['user']));
      if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
    } else if (body['error'] != null) {
      if (mounted) {
        var snackBar = SnackBar(
          content: Text(body['error']),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
