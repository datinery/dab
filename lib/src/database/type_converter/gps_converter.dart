import 'package:dab/dab.dart';
import 'package:floor/floor.dart';

class GPSConverter extends TypeConverter<GPS, String> {
  @override
  GPS decode(String value) {
    return GPS.parse(value);
  }

  @override
  String encode(GPS value) {
    return value.toString();
  }
}

class GPSNullableConverter extends TypeConverter<GPS?, String?> {
  @override
  GPS? decode(String? value) {
    if (value == null) return null;

    return GPS.parse(value);
  }

  @override
  String? encode(GPS? value) {
    return value?.toString();
  }
}
