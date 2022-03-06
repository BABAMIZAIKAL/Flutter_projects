// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'map.dart';
import 'package:location/location.dart';

class Homepage extends StatefulWidget{
  createState(){
    return HomepageState();
  }
}

class HomepageState extends State<Homepage>{

  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  // Check Location Permissions, and get my location
  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
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
    _locationData = await location.getLocation();
  }

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
              onTap: () => _locationData != null ?Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Map(location: _locationData,))) : null
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