import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  createState(){
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Widget build (context){
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            emailField(),
            passwordField(),
            Container(margin: EdgeInsets.only(top: 25.0)),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget emailField(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email:",
        hintText: "you@mail.com"
      ),
      validator: (String? value){
        if(!(value!.contains("@"))){
          return "Enter a valid email";
        }
      },
      onSaved: (String? value){
        email = value!;
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
        if(value!.length < 4){
          return "Ur password must be atleast 4 characters";
        }
      },
      onSaved: (String? value){
        password = value!;
      },
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
          print("Email: $email --> Password: $password");
        }
      },
    );
  }

}