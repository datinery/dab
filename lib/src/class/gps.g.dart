// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GPS _$GPSFromJson(Map<String, dynamic> json) => GPS(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$GPSToJson(GPS instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
