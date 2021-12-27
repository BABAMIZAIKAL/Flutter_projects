// ignore_for_file: prefer_const_constructors

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
  String usernameRegister = '';
  String password1 = '';
  String password2 = '';

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
      validator: (String? value){
        if(value!.length < 4){
          return "Your username must be atleast 4 characters";
        }
      },
      onSaved: (String? value){
        usernameRegister = value!;
      },
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
      validator: (String? value){
        if(value!.length < 3){
          return "Your password must be atleast 3 characters";
        }
      },
      onSaved: (String? value){
        password1 = value!;
      },
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
      validator: (String? value){
        if(value != password1 ){
          return "Your password must the same";
        }
      },
      onSaved: (String? value){
        password2 = value!;
      },
    );
  }

  Widget registerButton(){
    return TextButton(
      style: TextButton.styleFrom(
      primary: Colors.blue,
      ),
      onPressed: () { 
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
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
      onPressed: () {
        if(formKeyRegister.currentState!.validate()){
          formKeyRegister.currentState!.save();
          print("Username: $usernameRegister --> Password: $password1");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
        }
      },
    );
  }
}