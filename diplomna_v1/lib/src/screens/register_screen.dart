// ignore_for_file: prefer_const_constructors

import 'package:diplomna_v1/Database/DbHandler.dart';
import 'package:diplomna_v1/Models/UserModel.dart';
import 'package:diplomna_v1/Helper/DbHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:diplomna_v1/src/screens/login_screen.dart';
import 'homepage.dart';

class RegisterScreen extends StatefulWidget{
  createState(){
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen>{
  final formKeyRegister = GlobalKey<FormState>();

  final usernameRegister = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  var dbHandler;
  @override
  void initState() {
    super.initState();
    dbHandler = dbHandler();
  }

  signUp() async {
    String uname = usernameRegister.text;
    String passwd = password1.text;
    String cpasswd = password2.text;

    if (formKeyRegister.currentState!.validate()) {
      if (passwd != cpasswd) {
        //alertDialog(context, 'Password Mismatch');
      } else {
        formKeyRegister.currentState!.save();

        UserModel uModel = UserModel(uname, passwd);
        await dbHandler.saveData(uModel).then((userData) {
          //alertDialog(context, "Successfully Saved");

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }).catchError((error) {
          print(error);
          //alertDialog(context, "Error: Data Save Fail");
        });
      }
    }
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
          key: formKeyRegister,
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
                password1Field(),
                SizedBox(height:10),
                password2Field(),
                SizedBox(height: 20),
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
      // ignore: prefer_const_constructors
      decoration: InputDecoration(
        labelText: "Username:",
        hintText: "Enter Username"
      ),
    );
  }
  Widget password1Field(){
    return TextFormField(
      obscureText: true,
      // ignore: prefer_const_constructors
      decoration: InputDecoration(
        labelText: "Password:",
        hintText: "Enter Password"
      ),
    );
  }
  Widget password2Field(){
    return TextFormField(
      obscureText: true,
      // ignore: prefer_const_constructors
      decoration: InputDecoration(
        labelText: "Confirm Password:",
        hintText: "Enter Confirm Password"
      ),
    );
  }

  Widget registerButton(){
    return TextButton(
      style: TextButton.styleFrom(
      primary: Colors.blue,
      ),
      onPressed: () { 
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false);
      },
      // ignore: prefer_const_constructors
      child: Text('Sign in')
    );
  }

  Widget submitButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
      ),
      // ignore: prefer_const_constructors
      child: Text("Submit!"),
      onPressed: signUp,
    );
  }
}