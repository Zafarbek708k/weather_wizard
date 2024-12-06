// To parse this JSON data, do
//
//     final geoCodeModel = geoCodeModelFromJson(jsonString);

import 'dart:convert';

List<GeoCodeModel> geoCodeModelFromJson(String str) => List<GeoCodeModel>.from(json.decode(str).map((x) => GeoCodeModel.fromJson(x)));

String geoCodeModelToJson(List<GeoCodeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeoCodeModel {
  final String? name;
  final Map<String, String>? localNames;
  final double? lat;
  final double? lon;
  final String? country;
  final String? state;

  GeoCodeModel({
    this.name,
    this.localNames,
    this.lat,
    this.lon,
    this.country,
    this.state,
  });

  GeoCodeModel copyWith({
    String? name,
    Map<String, String>? localNames,
    double? lat,
    double? lon,
    String? country,
    String? state,
  }) =>
      GeoCodeModel(
        name: name ?? this.name,
        localNames: localNames ?? this.localNames,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        country: country ?? this.country,
        state: state ?? this.state,
      );

  factory GeoCodeModel.fromJson(Map<String, dynamic> json) => GeoCodeModel(
    name: json["name"],
    localNames: Map.from(json["local_names"]!).map((k, v) => MapEntry<String, String>(k, v)),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    country: json["country"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "local_names": Map.from(localNames!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "lat": lat,
    "lon": lon,
    "country": country,
    "state": state,
  };
}
