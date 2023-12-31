import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/custom_dialog.dart';
import 'package:recipe_sharing/widget/recipe_list.dart';
import 'package:recipe_sharing/widget/custom_radio_button.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin<Profile> {
  dynamic name;
  dynamic profile;
  dynamic image;
  dynamic _selected = 'Created';
  dynamic recipes;
  dynamic _shownRecipe;
  late bool loadRecipe;

  void initState() {
    super.initState();
    loadRecipe = true;
    _loadUserData();
    _loadProfileRecipe();
  }

  _loadUserData() async {
    const storage = FlutterSecureStorage();
    var userString = await storage.read(key: 'user');

    if (userString != null) {
      var user = jsonDecode(userString);

      setState(() {
        name = user['name'].toString();
        profile = user['profile'];
      });
    }
  }

  _onItemTapped(type) {
    if(mounted){
      setState(() {
        _selected = type;
        if(recipes != null){
          _shownRecipe = recipes[type.toString().toLowerCase()];
        }
      });
    }
  }

  void _editProfilePressed() {
    setState(() {
      _selected = "Saved";
    });
  }

  void _loadProfileRecipe() async {
    var res = await Network().getUserRecipeList();
    var body = jsonDecode(res.body);
    if(mounted){
      setState(() {
        recipes = body;
        _shownRecipe = recipes[_selected.toString().toLowerCase()];
        loadRecipe = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    dynamic img;

    if(profile != null){
      img = MemoryImage(base64Decode(profile));
    } else {
      img = NetworkImage('https://ui-avatars.com/api/?name=${name}&background=random&length=1');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          const SliverAppBar(
            collapsedHeight: 20,
            toolbarHeight: 20,
            backgroundColor: Colors.white,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: refreshData,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 38), 
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Hello, ",
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF242424),
                                  fontSize: 20,
                              ),
                              children: [
                                TextSpan(
                                    text: "$name\n",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                    text: "This is your ${_selected.toString().toLowerCase()} list",
                                    style: const TextStyle(fontSize: 14)
                                ),
                              ]
                            )
                          ),
                        )
                      ),
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple.shade100
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset('assets/images/svg/settings.svg', height: 18, width: 18),
                          onPressed: () => showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            context: context, 
                            builder: (context) => ProfileSetting()
                          ),
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 80, // Image radius
                      backgroundImage: img,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      Text("${recipes != null ? recipes['saved'].length : '...'}\nSaved", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 27),
                      Text("${recipes != null ? recipes['created'].length : '...'}\nCreated", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center, 
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/update_profile'), 
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF242424))
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRadioButton(label: 'Saved', isSelected: _selected == 'Saved', onPressed: _onItemTapped),
                      const SizedBox(width: 10),
                      CustomRadioButton(label: 'Created', isSelected: _selected == 'Created', onPressed: _onItemTapped)
                    ]
                  ),
                  const SizedBox(height: 30),
                  Text("$_selected List", textAlign: TextAlign.start),
                  RecipeList(recipes: _shownRecipe, isLoading: loadRecipe),
                ]
              )
            )
          )
        ]
      )
    );
  }

  Future refreshData() async {
    setState(() {
      loadRecipe = true;
    });
    _loadUserData();
    _loadProfileRecipe();
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}


class ProfileSetting extends StatefulWidget {
  ProfileSetting({Key? key}) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: 230,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Profile", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/update_profile'),
              child: Align(
                alignment: Alignment.centerLeft,
                child : Text("Edit Account Profile", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: HexColor("#242424"), fontWeight: FontWeight.w600))
              )
            ),
            TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmDialog(onConfirm: logout),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child : Text("Log out", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600))
              )
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF242424)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    var res = await Network().logout();
    if (res.statusCode == 200) {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
}