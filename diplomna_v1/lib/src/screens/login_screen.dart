import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:diplomna_v1/src/screens/register_screen.dart';

import 'homepage.dart';

class LoginScreen extends StatefulWidget{
  createState(){
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{
  final formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  
  Widget build(context){
    return Scaffold(
      body: Container(  
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
      validator: (String? value){
        if(value!.length < 4){
          return "Your username must be atleast 4 characters";
        }
      },
      onSaved: (String? value){
        username = value!;
      },
    );
  }
  Widget passwordField(){
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Enter Password:",
        hintText: "Password"
      ),
      validator: (String? value){
        if(value!.length < 3){
          return "Your password must be atleast 3 characters";
        }
      },
      onSaved: (String? value){
        password = value!;
      },
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
      onPressed: () {
        if(formKey.currentState!.validate()){
          formKey.currentState!.save();
          print("Username: $username --> Password: $password");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
        }
      },
    );
  }
}