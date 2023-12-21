import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:recipe_sharing/network/api.dart';
import 'package:recipe_sharing/widget/category_selection.dart';
import 'package:recipe_sharing/widget/custom_text_field.dart';

class PostRecipe extends StatefulWidget {
  const PostRecipe({super.key});

  @override
  State<PostRecipe> createState() => _PostRecipeState();
}

class _PostRecipeState extends State<PostRecipe> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionsController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  XFile? _imageFile;
  bool _pickingImage = false;
  bool _isLoading = false;
  List _selectedCategories = [];

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

  onApply(categories) {
    setState(() {
      _selectedCategories = categories;
    });

    Navigator.pop(context);
  }

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
                      padding: const EdgeInsets.only(top: 30, left: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepPurple.shade100
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_outlined),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 115,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 110,
                          backgroundColor: const Color.fromARGB(255, 119, 76, 11),
                          backgroundImage: (_imageFile != null)
                            ? FileImage(File(_imageFile!.path))
                            : null,
                          child: _imageFile == null
                            ? Icon(
                                Icons.camera_alt_outlined,
                                size: 45,
                                color: Colors.grey[400],
                              )
                            : null,
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                        child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 8, 30, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                const Text('Title', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(label: '40 Words Max', controller: _titleController, maxLength: 40),
                                const SizedBox(height: 15),
                                CategoryButton(selectedCategories: _selectedCategories, onApply: onApply),
                                const SizedBox(height: 30),
                                const Text('Description', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(label: '200 Words Max', controller: _descriptionsController, minLines: 1, maxLines: 20, maxLength: 200),
                                const SizedBox(height: 20),
                                const Text('Ingredients', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(label: '200 Words Max', controller: _ingredientsController, minLines: 1, maxLines: 20, maxLength: 200),
                                const SizedBox(height: 20),
                                const Text('Instructions',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(label: '400 Words Max', controller: _instructionsController, minLines: 1, maxLines: 20, maxLength: 400),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _handlePost,
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(const Size.fromHeight(5)),
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
                                  child: const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'Post This',
                                      style: TextStyle(fontWeight: FontWeight.bold)
                                    )
                                  ),
                                ),
                              ]
                            )
                          )
                        )
                      )
                    )
                  ]
                )
              )
            )
          );
        }
      )
    );
  }

  _handlePost() async {
    Uint8List? originalImage;
    Uint8List? compressedImage;

    String title = _titleController.text;
    String descriptions = _descriptionsController.text;
    String ingredients = _ingredientsController.text;
    String instructions = _instructionsController.text;
    List category = _selectedCategories;
    XFile? image = _imageFile;

    if(image != null){
      originalImage = await image.readAsBytes();
      compressedImage = await FlutterImageCompress.compressWithList(
        originalImage,
        quality: 20, // Adjust the quality as needed
      );
    }

    setState(() { 
      _isLoading = true;
    });

    var data = {
      'title': title, 
      'descriptions': descriptions,
      'ingredients': ingredients,
      'instructions': instructions,
      'category': category.join(","),
      'image': base64Encode(compressedImage!)
    };

    dynamic res = await Network().postRecipe(data);
    dynamic body = jsonDecode(res.body);

    if (res.statusCode == 200) {
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