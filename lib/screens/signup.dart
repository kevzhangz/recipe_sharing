import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:recipe_sharing/constant.dart';
import 'package:recipe_sharing/helpers/helpers.dart';
import 'package:recipe_sharing/widget/textfield_with_prefix_icon.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child : Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/lock.jpg', height: 170, width: 170, alignment: Alignment.center),
              const SizedBox(height: 50),
              const Text('Sign Up',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  text: 'Enter your ', 
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(text: 'Credentials', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' in the forms below'),
                  ]
                )
              ),
              const SizedBox(height: 35),
              TextFieldWithPrefixIcon(icon: 'assets/images/smile.png', label: 'Name', controller: _usernameController),
              const SizedBox(height: 16.0),
              TextFieldWithPrefixIcon(icon: 'assets/images/mail.png', label: 'Email', controller: _emailController),
              const SizedBox(height: 16.0),
              TextFieldWithPrefixIcon(icon: 'assets/images/password.png', label: 'Password', controller: _passwordController),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  // Add your signup logic here
                  String username = _usernameController.text;
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  dynamic response = await apiCall("$apiUrl/api/users",
                    {
                      'username': username, 
                      'name': username,
                      'email': email,
                      'password': password
                    }
                  );

                  if(response['message'] != null){
                    if(context.mounted) Navigator.pushReplacementNamed(context, '/login');
                  } else if(response['error'] != null){

                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(HexColor("#FF9E0C")),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold))
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Already have an account? ', 
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Log In', 
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
}