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

  // Check Location Permissions, and get my location
  /*void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("EVERYTHING OK");
    print(location.serviceEnabled().toString());
    print(location.hasPermission().toString());

    _locationData = await location.getLocation();
  }*/
  void getCurrentLocation() async{
    var position = await Geolocator.getLastKnownPosition();
    setState(() {
      latitudeData = '${position?.latitude}';
      longtitudeData = '${position?.longitude}';
    });
  }

  Widget build(context){
    //print(_locationData);
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
                latitudeData != null && longtitudeData != null
                    ? Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => Map(geoLat: latitudeData!, geoLng: longtitudeData,)))
                    : null;

              }
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Hello"),
      ),
      body: SingleChildScrollView(
      )
    );
  }
}