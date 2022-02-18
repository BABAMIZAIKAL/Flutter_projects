// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:diplomnav1/src/Pitch/location.dart';
import 'package:diplomnav1/src/Pitch/pitch.dart';
import 'package:diplomnav1/src/Pitch/tags.dart';
import 'package:diplomnav1/src/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:diplomnav1/src/Storage/secureStorage.dart';
import 'package:http/http.dart' as http;


class Map extends StatefulWidget{

  final LocationData location;
  Map({required this.location});

  createState(){
    return MapState();
  }
}

class MapState extends State<Map>{

  LatLng sofiaLocation = new LatLng(42.698334, 23.319941);
  //final storage = SecureStorage();
  //String token = SecureStorage.getToken() as String;

  Set<Polygon> _polygons = HashSet<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;






  @override
  void initState() {
    super.initState();
  }

  void _testMap(LatLng a){
    print("map");
  }
  void _testPolygon(){
    print("polygon");
  }

  void fetchPitches() async {
    var headers = {
      "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
    };
    final response = await http.get(Uri.parse('http://188.166.195.82:80/apigw/rest/api/v1/pitch/locate?latitude=42.6585174&longitude=23.3543216&radius=5000&type=FOOTBALL'), headers: headers );


    if (response.statusCode == 401) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
    }
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for(var p in jsonData){
        List<LatLng> coords = [];
        for (List<dynamic> coord in p['location']['coordinates']) {
          coords.add(LatLng(coord[0],coord[1]));
        }
        PitchLocation pitchLocation = PitchLocation(type: p['location']['type'], coordinates: coords , node_ids: p['location']['node_ids']);
        Pitch pitch1 = Pitch(id: p['id'], name: p['name'], type: p['type'], location: pitchLocation, wayId: p['wayId'], rolesRequired: ['rolesRequired']);
        print(pitch1.toString());
        _polygons.add(convertPitchToPolygon(pitch1));
      }
    } else {
      throw Exception('Failed to load pitches');
    }
  }

  static Polygon convertPitchToPolygon(Pitch a){
    List<LatLng> points = a.location.coordinates;
      return(Polygon(
        polygonId: PolygonId(a.id),
        points: points,
        fillColor: Colors.yellow,
        strokeWidth: 5,
      ));
  }

  Widget build(context){

    fetchPitches();
    print("HERE 1");
    for(Polygon p in _polygons){
      print(p);
    }

    return Scaffold(
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
            onTap: (LatLng a){
              _testMap(a);
            },
          ),
        ],
      ),
    );
  }
}