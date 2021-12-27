// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:diplomna_v1/src/screens/register_screen.dart';
import 'package:diplomna_v1/src/screens/login_screen.dart';
import 'package:diplomna_v1/src/screens/map.dart';

class Homepage extends StatefulWidget{
  createState(){
    return HomepageState();
  }
}

class HomepageState extends State<Homepage>{
  final formKey = GlobalKey<FormState>();
  String username = 'Misho';
  String password = '';
  
  Widget build(context){
    return Scaffold(
      // ignore: unnecessary_new
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Text("Homepage drawer"),
              decoration: BoxDecoration(color: Colors.blueGrey),
            ),
            ListTile(
              title: const Text('Map'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Map()));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Hello, $username")
      ),
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
      )
    );
  }
}