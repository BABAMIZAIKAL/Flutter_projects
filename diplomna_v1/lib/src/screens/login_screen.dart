// ignore_for_file: prefer_const_constructors

import 'package:diplomna_v1/Helper/DbHelper.dart';
import 'package:diplomna_v1/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:diplomna_v1/src/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class LoginScreen extends StatefulWidget{
  createState(){
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{

  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  final formKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final password = TextEditingController();
  var dbHandler;
  @override
  void initState() {
    super.initState();
    dbHandler = dbHandler();
  }

  login() async {
    String uname = username.text;
    String passwd = password.text;

    if (uname.isEmpty) {
      alertDialog(context, "Please Enter User Username");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHandler.getLoginUser(uname, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Homepage()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await preferences;
    //String? temp_username = user.user_name;
    //String? temp_password = user.password;
    //if(user.user_name != null && user.password != null){
    sp.setString("user_name", user.user_name);
    sp.setString("password", user.password);
    //}
  }

  
  Widget build(context){
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
          )
        ),
        child: Form(
          key: formKey,
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
                SizedBox(height:50),
                usernameField(),
                SizedBox(height:20),
                passwordField(),
                //SizedBox(height:20),
                registerButton(),
                submitButton(),
              ],
            ),
          )
        ),
      )
    );
  }

  Widget usernameField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Username:",
        hintText: "username"
      ),
    );
  }
  Widget passwordField(){
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Enter Password:",
        hintText: "Password"
      ),
    );
  }

  Widget registerButton(){
    return TextButton(
      style: TextButton.styleFrom(
      primary: Colors.blue,
      ),
      onPressed: () { 
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen()));
      },
      child: Text('Sign up')
    );
  }

  Widget submitButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
      ),
      child: Text("Submit!"),
      onPressed: login,
    );
  }
}