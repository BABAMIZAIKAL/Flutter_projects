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
  final formKeyRegister = new GlobalKey<FormState>();

  final usernameRegister = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  var dbHandler;
  @override
  void initState() {
    super.initState();
    dbHandler = DbHandler();
  }

  signUp() async {
    String uname = usernameRegister.text;
    String passwd = password1.text;
    String cpasswd = password2.text;


    if (formKeyRegister.currentState!.validate()) {
      if (passwd != cpasswd) {
        alertDialog(context, 'Password Mismatch');
      } else {
        formKeyRegister.currentState!.save();
        print("Data1: $uname $passwd $cpasswd");
        //print("Data2: $usernameRegister $password1 $password2");
        UserModel uModel = UserModel(uname, passwd);
        await dbHandler.saveData(uModel).then((userData) {
          alertDialog(context, "Successfully Saved");

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }).catchError((error) {
          print(error);
          alertDialog(context, "Error: Data Save Fail");
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
                  "Sign up",
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: usernameRegister,
        obscureText: false,
        enabled: true,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter username';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Username',
          labelText: 'Username',
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
  Widget password1Field(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: password1,
        obscureText: true,
        enabled: true,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Password',
          labelText: 'Password',
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
  Widget password2Field(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: password2,
        obscureText: true,
        enabled: true,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter confirmation password';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          labelText: 'Confirm Password',
          fillColor: Colors.grey[200],
          filled: true,
        ),
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