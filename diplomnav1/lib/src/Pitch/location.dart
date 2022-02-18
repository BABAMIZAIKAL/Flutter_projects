
import 'dart:collection';
import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class PitchLocation{
  final String type;
  List<LatLng> coordinates;
  var node_ids;

  PitchLocation({
    required this.type,
    required this.coordinates,
    required this.node_ids,
  });

  @override
  String toString() {
    return 'PitchLocation{type: $type, coordinates: $coordinates, node_ids: $node_ids}';
  }

  factory PitchLocation.fromJson(Map<String, dynamic> json) {
    return PitchLocation(
      type: json['type'],
      coordinates: json['coordinates'],
      node_ids: json['node_ids'],
    );
  }
}