import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // 1. Define a `GlobalKey` as part of the parent widget's state
  final _introKey = GlobalKey<IntroductionScreenState>();
  String _status = 'Waiting...';

  static const pageDecoration = PageDecoration(
    titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
    bodyTextStyle: TextStyle(fontSize: 14.0),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: const Color(0xFFFF9E0C),
  );

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width, height: width);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        // 2. Pass that key to the `IntroductionScreen` `key` param
        key: _introKey,
        globalBackgroundColor:const Color(0xFFFF9E0C),
        allowImplicitScrolling: true,
        autoScrollDuration: 5000,
        infiniteAutoScroll: true,
        globalHeader: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Padding(
                padding: EdgeInsets.only(right: 30, top: 75),
                child: Text("Skip", style: TextStyle(fontSize: 16, color: Colors.white))
              )
            )
          ),
        rawPages: [
          IntroPage(
            image: Image.asset('assets/images/burger.png', width: 250, height: 250), 
            title: "Welcome to Strudell!",
            body: RichText(
              text: const TextSpan(
                text: "Welcome to Strudell, your culinary hub! 🍽️ Discover and share delightful recipes with fellow ",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white
                ),
                children: [
                  TextSpan(text: 'food enthusiasts.', style: TextStyle(fontWeight: FontWeight.w600))
                ]
              )
            )
          ),
          IntroPage(
            image: Image.asset('assets/images/preview_screen.png', width: 250, height: 250), 
            title: "Start Your Culinary Adventure",
            body: RichText(
              text: const TextSpan(
                text: "Join us! Create a Strudell account to access thousands of recipes. Start your culinary ",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white
                ),
                children: [
                  TextSpan(text: 'adventure ', style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: 'now! 👩‍🍳👨‍🍳')
                ]
              )
            )
          ),
        ],
        onDone: () => Navigator.pushReplacementNamed(context, '/login'),
        showSkipButton: false,
        nextFlex: 0,
        dotsFlex: 10,
        showBackButton: false,
        showBottomPart: true,
        //rtl: true, // Display as right-to-left
        next: nextButton(),
        done: nextButton(),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.only(left: 32),
        controlsPadding: const EdgeInsets.all(12.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Colors.white,
          spacing: EdgeInsets.all(3),
          activeSize: Size(30.0, 10.0),
          activeColor: Colors.white,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      )
    );
  }

  Widget nextButton(){
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: const Icon(Icons.keyboard_arrow_right, color: Color(0xFFFF9E0C)),
    );
  }
}

class IntroPage extends StatelessWidget {
  IntroPage({ super.key, required this.image, required this.title, required this.body});

  Widget image;
  String title;
  Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 200),
        image,
        const SizedBox(height: 75),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 60),
          child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 60),
          child: body,
        )
      ],
    );
  }
}