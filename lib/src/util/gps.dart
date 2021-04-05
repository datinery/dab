import 'dart:math' as math;

import 'package:quiver/core.dart';

class GPS {
  double lat;
  double lng;

  GPS({required this.lat, required this.lng});

  factory GPS.parse(String value) {
    final latLng = value.split(' ').map(double.parse).toList();

    return GPS(lng: latLng[0], lat: latLng[1]);
  }

  String serialize() {
    return '$lng,$lat';
  }

  double distanceTo(GPS gps) {
    // https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula
    final p = math.pi / 180;
    final a = 0.5 -
        math.cos((gps.lat - lat) * p) / 2 +
        math.cos(lat * p) *
            math.cos(gps.lat * p) *
            (1 - math.cos((gps.lng - lng) * p)) /
            2;

    return 12742 * math.asin(math.sqrt(a));
  }

  @override
  String toString() {
    return '$lng,$lat';
  }

  @override
  bool operator ==(Object other) {
    return other is GPS && lat == other.lat && lng == other.lng;
  }

  @override
  int get hashCode => hash2(lat, lng);
}
