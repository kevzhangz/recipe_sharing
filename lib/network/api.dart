import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_sharing/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Network {
  final String _url = apiUrl;
  var token;

  _getToken() async {
    const storage = FlutterSecureStorage();
    var tokenString = await storage.read(key: 'token');
    if (tokenString != null) {
      token = jsonDecode(tokenString);
    }
  }

  auth(data) async {
    var fullUrl = Uri.parse('$_url/signin');
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  register(data) async {
    var fullUrl = Uri.parse('$_url/users');
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  logout() async {
    var fullUrl = Uri.parse('$_url/signout');
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  getRecipeList({limit}) async {
    String query = '';
    if(limit != null){
      query = "?limit=$limit";
    }

    var fullUrl = Uri.parse('$_url/recipe$query');
    await _getToken();

    return await http.get(
      fullUrl,
      headers: _setHeaders(auth: true),
    );
  }

  getUserRecipeList() async {
    var fullUrl = Uri.parse('$_url/recipe/user');
    await _getToken();

    return await http.get(
      fullUrl,
      headers: _setHeaders(auth: true),
    );
  }

  postRecipe(data) async {
    var fullUrl = Uri.parse('$_url/recipe');
    await _getToken();

    return await http.post(fullUrl,
      body: jsonEncode(data), 
      headers: _setHeaders(auth: true)
    );
  }

  rateRecipe(recipeId, data) async {
    var fullUrl = Uri.parse('$_url/recipe/$recipeId/rate');
    await _getToken();

    return await http.post(fullUrl,
      body: jsonEncode(data), 
      headers: _setHeaders(auth: true)
    );
  }

    saveRecipe(recipeId, data) async {
    var fullUrl = Uri.parse('$_url/recipe/$recipeId/save');
    await _getToken();

    return await http.post(fullUrl,
      headers: _setHeaders(auth: true)
    );
  }

  _setHeaders({auth = false}) {
    var header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    if(auth){
      header['Authorization'] = "Bearer $token";
    }

    return header;
  }
}
