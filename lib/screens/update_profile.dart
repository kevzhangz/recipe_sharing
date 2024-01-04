import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recipe_sharing/network/api.dart';


class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController _nameController = TextEditingController();
  String? name;
  bool _pickingImage = false;
  bool _isLoading = false;
  dynamic _imageFile;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    const storage = FlutterSecureStorage();
    var userString = await storage.read(key: 'user');

    if (userString != null) {
      var user = jsonDecode(userString);

      print(user['profile']);

      setState(() {
        name = user['name'];
        _nameController = TextEditingController(text: user['name'].toString());
        email = user['email'];
        if(user['profile'] != null){
          _imageFile = base64Decode(user['profile']);
        }
      });
    }
  }

    Future<void> _pickImage() async {
    if(_pickingImage){
      return;
    }

    _pickingImage = true;
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);

    if(pickedFile != null){
      setState(() {
        _imageFile = pickedFile;
      });
    }

    _pickingImage = false;
  }

  @override
  Widget build(BuildContext context) {
    dynamic img;

    if(_imageFile is XFile){
      img = FileImage(File(_imageFile!.path));
    } else if(_imageFile != null){
      img = MemoryImage(_imageFile);
    } else {
      img = NetworkImage('https://ui-avatars.com/api/?name=${name}&background=random&length=1');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple.shade100
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_outlined),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: "Edit Profile ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )
                  ),
                  const SizedBox(width: 40)
                ]
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: const Color.fromARGB(255, 119, 76, 11),
                    backgroundImage: img,
                  )
                )
              ),
              const SizedBox(height: 20),
              const Text("Username", style: TextStyle(fontWeight: FontWeight.w500)),
              TextField(
                controller: _nameController,
              ),
              const SizedBox(height: 360),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(HexColor("#FF9E0C")),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          _isLoading ? 'Processing...' : 'Apply Changes',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                        )
                      ),
                    ), 
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.bold, color:Colors.black)
                      )
                    ),
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }

  _updateProfile() async {
    Uint8List? originalImage;
    Uint8List? compressedImage;
    
    String name = _nameController.text;
    dynamic image = _imageFile;

    setState(() { 
      _isLoading = true;
    });

    var data = {
      'username': name.replaceAll(' ', '_').toLowerCase(),
      'name': name,
    };

    if(image is XFile){
      originalImage = await image.readAsBytes();
      compressedImage = await FlutterImageCompress.compressWithList(
        originalImage,
        quality: 20, // Adjust the quality as needed
      );

      data['profile'] = base64Encode(compressedImage);
    }

    dynamic res = await Network().updateProfile(email, data);
    dynamic body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'user', value: json.encode(body));

      if (context.mounted){
        Navigator.pop(context);
        Navigator.pop(context);
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