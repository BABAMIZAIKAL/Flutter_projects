import 'dart:convert';

import 'package:diplomnav1/src/Storage/secureStorage.dart';
import 'package:diplomnav1/src/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

sendRequest(var url) async {
  var headers = {
  "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
  };
  final response = await http.get(Uri.parse(url), headers: headers );
  var jsonData = jsonDecode(response.body);

  if(response.statusCode == 401){
    return 0;
  }

  if (response.statusCode == 200) {
    return jsonData;
  }
}