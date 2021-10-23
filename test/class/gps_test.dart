import 'package:dab/dab.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Serializing and deserializing GPS works', () {
    final lat = 37.506305;
    final lng = 127.0560695;
    final serializedGPS = '$lng,$lat';

    final gps = GPS.parse(serializedGPS);
    expect(gps.lat, lat);
    expect(gps.lng, lng);
    expect(gps.serialize(), serializedGPS);
  });
}
