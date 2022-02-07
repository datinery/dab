import 'dart:convert';
import 'dart:math' as math;

import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

part 'gps.g.dart';

@JsonSerializable()
class GPS {
  double lat;
  double lng;

  GPS({required this.lat, required this.lng});

  double distanceToInMeters(GPS gps) {
    // https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula
    final p = math.pi / 180;
    final a = 0.5 -
        math.cos((gps.lat - lat) * p) / 2 +
        math.cos(lat * p) *
            math.cos(gps.lat * p) *
            (1 - math.cos((gps.lng - lng) * p)) /
            2;

    return 12742 * math.asin(math.sqrt(a)) * 1000; // meters
  }

  factory GPS.fromJson(Map<String, dynamic> json) => _$GPSFromJson(json);
  Map<String, dynamic> toJson() => _$GPSToJson(this);

  factory GPS.deserialize(String value) {
    return GPS.fromJson(jsonDecode(value));
  }
  String serialize() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    return other is GPS && lat == other.lat && lng == other.lng;
  }

  @override
  int get hashCode => hash2(lat, lng);
}
