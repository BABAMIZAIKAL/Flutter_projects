// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:diplomnav1/src/Pitch/location.dart';
import 'package:diplomnav1/src/Pitch/pitch.dart';
import 'package:diplomnav1/src/Pitch/tags.dart';
import 'package:diplomnav1/src/Request/sendRequest.dart';
import 'package:diplomnav1/src/screens/homepage.dart';
import 'package:diplomnav1/src/screens/login_screen.dart';
import 'package:diplomnav1/src/screens/pitch_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:diplomnav1/src/Storage/secureStorage.dart';
import 'package:http/http.dart' as http;


class Map extends StatefulWidget{

  final String geoLat;
  final String geoLng;
  Map({required this.geoLat, required this.geoLng});

  createState(){
    return MapState();
  }
}

class MapState extends State<Map>{

  LatLng sofiaLocation = new LatLng(42.698334, 23.319941);

  var _polygons = new HashSet<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  String? currLat;
  String? currLng;




  @override
  void initState() {
    super.initState();
    currLat = widget.geoLat;
    currLng = widget.geoLng;
    fetchPitches();
  }

  void _testMap(LatLng a){
    print("map");
  }
  void _testPolygon(){
    print("polygon");
  }

  void fetchPitches() async {


    // currLng = '42.698334';
    // currLat = '23.319941';

    String url = apiUrl + '/pitch/locate?latitude='+currLat!+'&longitude='+currLng!+'&radius=2000&type=FOOTBALL';
    print(url);
    var jsonData = await sendRequest(url, 'get', 'null');
    if(jsonData == 0){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
      return;
    }
    for(var p in jsonData){
      List<LatLng> coords = [];
      for (List<dynamic> coord in p['location']['coordinates']) {
        coords.add(LatLng(coord[0],coord[1]));
      }
      PitchLocation pitchLocation = PitchLocation(type: p['location']['type'], coordinates: coords , node_ids: p['location']['node_ids']);
      Pitch pitch = Pitch(id: p['id'], name: p['name'], type: p['type'], location: pitchLocation, /*wayId: p['wayId'],*/ rolesRequired: ['rolesRequired'], pitch_image: p['attachment_uri']);
      _polygons.add(convertPitchToPolygon(pitch));
    }
    print(_polygons.length);
    setState(() {
      setPolygons(_polygons);
    });

  }
  void setPolygons(HashSet<Polygon> set){
    _polygons.addAll(set);
  }

  Polygon convertPitchToPolygon(Pitch a){
    List<LatLng> points = a.location.coordinates;
    return Polygon(
      polygonId: PolygonId(a.id),
      points: points,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.25),
      consumeTapEvents: true,
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PitchView(sentPitch: a)));
      }
    );
  }


  Widget build(context){

    return  Scaffold(
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new DrawerHeader(
              child: Text("Map drawer"),
              decoration: new BoxDecoration(color: Colors.blueGrey),
            ),
            ListTile(
              title: const Text('Homepage'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Hello")
      ),

      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(sofiaLocation.latitude, sofiaLocation.longitude),
              zoom: 10,
            ),
            mapType: MapType.hybrid,
            polygons: _polygons,
            myLocationEnabled: true,
          ),
        ],
      ),
    );
  }
}