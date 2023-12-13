import 'dart:convert';

import 'package:http/http.dart' as http;

apiCall(link, body) async {
  var url = Uri.parse(link);
  var response = await http.post(url, 
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(body)
  );

  return jsonDecode(response.body);
}