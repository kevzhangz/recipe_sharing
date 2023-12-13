import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/gestures.dart';

import 'package:recipe_sharing/helpers/helpers.dart';
import 'package:recipe_sharing/constant.dart';
import 'package:recipe_sharing/widget/textfield_with_prefix_icon.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: HexColor("#FF9E0C"),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              ),
              child : IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Image.asset("assets/images/chef.png", height: 300, width: 300),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
                        child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 16, 30, 16), 
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 40),
                                const Text('Login',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                                ),
                                const SizedBox(height: 20),
                                RichText(
                                  text: const TextSpan(
                                    text: 'Enter your ', 
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(text: 'Email ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: 'and '),
                                      TextSpan(text: 'Password', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]
                                  )
                                ),
                                const SizedBox(height: 35),
                                TextFieldWithPrefixIcon(icon: 'assets/images/mail.png', label: 'Email', controller: _emailController),
                                const SizedBox(height: 16),
                                TextFieldWithPrefixIcon(icon: 'assets/images/password.png', label: 'Password', controller: _passwordController),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: () async {
                                    // Add your signup logic here
                                    String email = _emailController.text;
                                    String password = _passwordController.text;

                                    dynamic response = await apiCall("$apiUrl/api/signin",
                                      {
                                        'email': email,
                                        'password': password
                                      }
                                    );

                                    if(response['message'] != null){
                                      if(context.mounted) Navigator.pushReplacementNamed(context, '/home');
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
                                    child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold))
                                  ),
                                ),
                                const SizedBox(height: 15),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'Dont have an account? ', 
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: 'Sign up', 
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.pushReplacementNamed(context, '/register')
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
}