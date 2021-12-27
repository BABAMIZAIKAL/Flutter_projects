// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:diplomna_v1/src/screens/register_screen.dart';
import 'package:diplomna_v1/src/screens/login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget{
  createState(){
    return MapState();
  }
}

class MapState extends State<Map>{
  final formKey = GlobalKey<FormState>();
  String username = 'Misho';
  String password = '';
  
  Widget build(context){
    return Scaffold(
      // ignore: unnecessary_new
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new DrawerHeader(
              child: Text("Map drawer"),
              decoration: new BoxDecoration(color: Colors.blueGrey),
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Hello, $username")
      ),
      body: GoogleMap(initialCameraPosition: 
        CameraPosition(
          target: LatLng(42.698334, 23.319941),
          zoom: 10,
        ),
      ),
    );
  }
}