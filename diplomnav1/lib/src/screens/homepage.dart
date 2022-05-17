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
  String hardcodeLat = "42.671101";
  String hardcodeLng = "23.297514";

  @override
  void initState() {
    super.initState();
    //_checkLocationPermission();
    getCurrentLocation();
  }


  void getCurrentLocation() async{
    try{
      var position = await Geolocator.getLastKnownPosition();
      setState(() {
        latitudeData = '${position?.latitude}';
        longtitudeData = '${position?.longitude}';
      });
    }on Exception catch(e){
      latitudeData = "42.671101";
      longtitudeData = "23.297514";
      print(e);
    }

  }
//42.671101, 23.297514
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
                :
            null;
          }, child: Text('Map'),
        ),
      )
    );
  }
}