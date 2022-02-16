
import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class Location{
  final String type;
  final List<LatLng> coordinates;
  final List<Double> node_ids;

  Location({
    required this.type,
    required this.coordinates,
    required this.node_ids,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'],
      node_ids: json['node_ids'],
    );
  }
}