// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:collection';
import 'dart:convert';

import 'package:diplomnav1/src/Pitch/pitch.dart';
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

  List<Pitch> pitches = [];




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

  Future<Pitch> fetchAlbum() async {

    var headers = {
      "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
    };
    print(await SecureStorage.getToken() as String);
    final response = await http.get(Uri.parse('http://188.166.195.82:80/apigw/rest/api/v1/pitch/locate?latitude=42.6585174&longitude=23.3543216&radius=5000&type=FOOTBALL'), headers: headers );



    if (response.statusCode == 401) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
    }
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for(var p in jsonData){
        Pitch pitch = Pitch(id: p['id'], name: p['name'], type: p['type'], location: p['location'], rolesRequired: p['rolesRequired'], wayId: p['wayId'], tags: p['tags']);
        print(p);
        print("here");
        pitches.add(pitch);
      }
      return Pitch.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygonLatLngs,
      strokeWidth: 5,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.15),
      consumeTapEvents: true,
      onTap: () {
        _testPolygon();
      }
    ));
  }
  void _setCustomPolygon(){
    LatLng point1 = new LatLng(42.662569, 23.299392);
    LatLng point2 = new LatLng(42.662976, 23.299625);
    LatLng point3 = new LatLng(42.663124, 23.299011);
    LatLng point4 = new LatLng(42.662803, 23.298963);
    polygonLatLngs.add(point1);
    polygonLatLngs.add(point2);
    polygonLatLngs.add(point3);
    polygonLatLngs.add(point4);
  }

  Widget build(context){



    _setCustomPolygon();
    _setPolygon();
    fetchAlbum();
    print(pitches);

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