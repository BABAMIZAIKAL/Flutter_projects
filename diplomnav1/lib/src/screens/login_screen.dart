// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:diplomnav1/src/Request/sendRequest.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'homepage.dart';
import 'package:diplomnav1/src/widgets/delay.dart';
import 'package:diplomnav1/src/Storage/secureStorage.dart';

class LoginScreen extends StatefulWidget{
  createState(){
    return LoginScreenState();
  }
}

String oid = '';
String apiUrl = 'http://sportonapp.me/apigw/rest/api/v1';
String apiUsername = '';
String role = '';

class LoginScreenState extends State<LoginScreen>{


  static final Config config = new Config(
      tenant: "sportontestad",
      clientId: "17608c8d-7e70-4fb7-974e-c0fab81aaef6",
      scope: "openid 17608c8d-7e70-4fb7-974e-c0fab81aaef6 offline_access",
      redirectUri: "msauth://com.example.diplomnav1/gYfucgrOlZ3FLWgYctqk1bCxZbo%3D",
      isB2C: true,
      policy: "b2c_1_sportontest_local"
  );
  final AadOAuth oauth = new AadOAuth(config);

  String globalAccessToken = "";
  final storage = SecureStorage();
  final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);


  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );


  Future<void> _logIn() async {
    try {

      await oauth.login();

      String? accessToken = await oauth.getAccessToken();

      Map<String, dynamic> payload = Jwt.parseJwt(accessToken!);
      print("TUK" + accessToken + "TUK");
      print(payload);
      var userId = payload["oid"];
      var username = payload["name"];
      var mail = payload["emails"][0];
      apiUsername = username;

      SecureStorage.setToken(accessToken);
      SecureStorage.setOid(userId);
      oid = userId;
      String url = apiUrl + '/user';

      if(payload.containsKey("newUser") && payload["newUser"] == true){
        print(userId + username + mail);

        Map data = {
          'user_id': userId,
          'username': username,
          'email' : mail
        };
        //encode Map to JSON
        var body = json.encode(data);

        var jsonData = await sendRequest(url, 'post', body);
        role = jsonData["role"];
      }else{
        var jsonDate = await sendRequest(url + '/' + oid, 'get', null);
        role = jsonDate["role"];
        print(role);
        print(jsonDate);
      }


      if(accessToken != null){
        Future.delayed(Duration(seconds: 5),(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
        });
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
  }


  
  Widget build(context){
    _logIn();
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,

        child: Form(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SpinKitFadingCircle(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.red : Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ),
      )
    );
  }
}