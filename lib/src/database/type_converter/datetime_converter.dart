import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String value) {
    return DateTime.parse(value);
  }

  @override
  String encode(DateTime value) {
    return value.toIso8601String();
  }
}

class DateTimeNullableConverter extends TypeConverter<DateTime?, String?> {
  @override
  DateTime? decode(String? value) {
    if (value == null) return null;

    return DateTime.parse(value);
  }

  @override
  String? encode(DateTime? value) {
    return value?.toIso8601String();
  }
}
