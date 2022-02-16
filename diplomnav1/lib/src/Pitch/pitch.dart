import 'package:diplomnav1/src/Pitch/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pitch {
  final String id;
  final String name;
  final String type;
  final Location location;
  final List<String> rolesRequired;
  final int wayId;
  final Map<String, String> tags;


  const Pitch({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.rolesRequired,
    required this.wayId,
    required this.tags,

  });

  factory Pitch.fromJson(Map<String, dynamic> json) {
    return Pitch(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      location: json['location'],
      rolesRequired: json['rolesRequired'],
      wayId: json['wayId'],
      tags: json['tags'],
    );
  }
}