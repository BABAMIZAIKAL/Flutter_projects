// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'homepage.dart';
import 'package:diplomnav1/src/widgets/delay.dart';
import 'package:diplomnav1/src/Storage/secureStorage.dart';

class LoginScreen extends StatefulWidget{
  createState(){
    return LoginScreenState();
  }
}

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

      //await storage.write(key: "accessToken", value: accessToken);
      SecureStorage.setToken(accessToken!);
      SecureStorage.getToken();

      //final String? storageToken = await storage.read(key: "accessToken");
      //print(storageToken);
      if(accessToken != null){
        //delay(10000);
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // ignore: prefer_const_literals_to_create_immutables
            colors: [
              Color(0xffdddd33),
              Color(0xffe0e047),
              Color(0xffe3e35b),
              Color(0xffe7e770),
              Color(0xffeaea84),
            ]
          ),

        ),
        child: Form(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.white,
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