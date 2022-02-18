import 'package:diplomnav1/src/Pitch/location.dart';
import 'package:diplomnav1/src/Pitch/tags.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pitch {
  final String id;
  final String name;
  final String type;
  final PitchLocation location;
  final List<String> rolesRequired;
  final int wayId;
  //final Tags tags;


  const Pitch({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.rolesRequired,
    required this.wayId,
    //required this.tags,

  });


  @override
  String toString() {
    return 'Pitch{id: $id, name: $name, type: $type, location: $location, rolesRequired: $rolesRequired, wayId: $wayId}';
  }

  factory Pitch.fromJson(Map<String, dynamic> json) {
    return Pitch(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      location: json['location'],
      rolesRequired: json['rolesRequired'] as List<String>,
      wayId: json['wayId'],
      //tags: json['tags'],
    );
  }
}