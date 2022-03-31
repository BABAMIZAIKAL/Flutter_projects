// ignore_for_file: prefer_const_constructors

//import 'dart:html';

import 'package:flutter/material.dart';
import 'map.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';


class Homepage extends StatefulWidget{
  createState(){
    return HomepageState();
  }
}

class HomepageState extends State<Homepage>{

  /*Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;*/
  String latitudeData = "";
  String longtitudeData = "";

  @override
  void initState() {
    super.initState();
    //_checkLocationPermission();
    getCurrentLocation();
  }


  void getCurrentLocation() async{
    var position = await Geolocator.getLastKnownPosition();
    setState(() {
      latitudeData = '${position?.latitude}';
      longtitudeData = '${position?.longitude}';
    });
  }

  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            latitudeData != null && longtitudeData != null
            ? Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => Map(geoLat: latitudeData!, geoLng: longtitudeData,)))
                : null;
          }, child: Text('Map'),
        ),
      )
    );
  }
}