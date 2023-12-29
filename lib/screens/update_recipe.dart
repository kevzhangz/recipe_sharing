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

class UpdateRecipe extends StatefulWidget {
  UpdateRecipe({super.key, required this.recipe});

  dynamic recipe;

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionsController = TextEditingController();
  TextEditingController _ingredientsController = TextEditingController();
  TextEditingController _instructionsController = TextEditingController();

  dynamic _imageFile;
  bool _pickingImage = false;
  bool _isLoading = false;
  List _selectedCategories = [];

  void initState(){
    super.initState();

    _titleController = TextEditingController(text: widget.recipe['title']);
    _descriptionsController = TextEditingController(text: widget.recipe['descriptions']);
    _ingredientsController = TextEditingController(text: widget.recipe['ingredients']);
    _instructionsController = TextEditingController(text: widget.recipe['instructions']);
    _selectedCategories = widget.recipe['category'];
    _imageFile = base64Decode(widget.recipe['image']);
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

  onApply(categories) {
    setState(() {
      _selectedCategories = categories;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    dynamic img;

    if(_imageFile is XFile){
      img = FileImage(File(_imageFile!.path));
    } else {
      img = MemoryImage(_imageFile);
    }

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
                    Align(
                      alignment: Alignment.topLeft, 
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40, left: 15),
                        child: Container(
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 115,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 110,
                          foregroundColor: Colors.black.withOpacity(0.5),
                          backgroundImage: img,
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
                                const SizedBox(height: 5),
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
                                  onPressed: _isLoading ? null : _handleUpdate,
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
                                      'Update',
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

  _handleUpdate() async {
    Uint8List? originalImage;
    Uint8List? compressedImage;

    String title = _titleController.text;
    String descriptions = _descriptionsController.text;
    String ingredients = _ingredientsController.text;
    String instructions = _instructionsController.text;
    List category = _selectedCategories;
    dynamic image = _imageFile;

    if(image != null && image is XFile){
      originalImage = await image.readAsBytes();
      compressedImage = await FlutterImageCompress.compressWithList(
        originalImage,
        quality: 20, // Adjust the quality as needed
      );
    }

    setState(() { 
      _isLoading = true;
    });

    if(image == null){
      if(mounted){
        var snackBar = const SnackBar(
          content: Text('Image must be added'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() { 
          _isLoading = false;
        });
      }

      return;
    }

    var data = {
      'title': title, 
      'descriptions': descriptions,
      'ingredients': ingredients,
      'instructions': instructions,
      'category': category.join(","),
    };

    if(compressedImage != null){
      data['image'] = base64Encode(compressedImage);
    }

    dynamic res = await Network().updateRecipe(widget.recipe['recipe_id'], data);
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