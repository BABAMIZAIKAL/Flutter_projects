import 'dart:convert';

import 'package:diplomnav1/src/Storage/secureStorage.dart';
import 'package:diplomnav1/src/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

sendRequest(var url, String type, var body) async {
  var headers = {
    "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
    "Content-type": "application/json",
  };
  var response;

  if (type == 'get') {
    response = await http.get(Uri.parse(url), headers: headers);
  } else if (type == 'post') {
    response = await http.post(Uri.parse(url), headers: headers, body: body);
  } else if (type == 'patch') {
    response = await http.patch(Uri.parse(url), headers: headers, body: body);
  } else if (type == 'put') {
    response = await http.put(Uri.parse(url), headers: headers, body: body);
  } else if (type == 'delete') {
    response = await http.delete(Uri.parse(url), headers: headers);
  }

  print(response.statusCode);
  if (response.statusCode == 401) {

    return 0;
  }

  if (response.statusCode == 200 || response.statusCode == 201) {
    var jsonData = jsonDecode(response.body);
    return jsonData;
  }
}
