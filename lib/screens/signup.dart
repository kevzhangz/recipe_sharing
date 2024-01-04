import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/lock.jpg',
                  height: 180, width: 180, alignment: Alignment.center
              ),
              const SizedBox(height: 50),
              const Text('Sign Up',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  text: 'Enter your ',
                  style: TextStyle(color: Color(0xFF242424), fontSize: 14, fontFamily: 'Poppins'),
                  children: [
                    TextSpan(
                        text: 'Credentials',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: ' in the forms below'),
                  ]
                )
              ),
              const SizedBox(height: 35),
              CustomTextField(
                  icon: 'assets/images/smile.png',
                  label: 'Name',
                  controller: _nameController),
              const SizedBox(height: 16.0),
              CustomTextField(
                  icon: 'assets/images/mail.png',
                  label: 'Email',
                  controller: _emailController),
              const SizedBox(height: 16.0),
              CustomTextField(
                  icon: 'assets/images/password.png',
                  label: 'Password',
                  controller: _passwordController),
              const SizedBox(height: 32.0),
              OutlinedButton(
                onPressed: _isLoading ? null : _register,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(HexColor("#FF9E0C")),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_isLoading ? 'Processing...' : 'Sign Up', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white))
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Color(0xFF242424), fontSize: 14, fontFamily: 'Poppins'),
                  children: [
                    TextSpan(
                      text: 'Log In',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacementNamed(context, '/login')
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    // Add your signup logic here
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    var data = {
      'username': name.replaceAll(' ', '_').toLowerCase(),
      'name': name,
      'email': email,
      'password': password
    };

    dynamic res = await Network().register(data);
    dynamic body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (mounted) {
        var snackBar = SnackBar(
          content: Text(body['message']),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacementNamed(context, '/login');
      }
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
