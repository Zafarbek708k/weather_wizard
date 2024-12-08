

// To parse this JSON data, do
//
//     final mockApiWeatherModel = mockApiWeatherModelFromJson(jsonString);

import 'dart:convert';

List<MockApiWeatherModel> mockApiWeatherModelFromJson(String str) => List<MockApiWeatherModel>.from(json.decode(str).map((x) => MockApiWeatherModel.fromJson(x)));

String mockApiWeatherModelToJson(List<MockApiWeatherModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MockApiWeatherModel {
  final String? id;
  final String? cityName;
  final String? lat;
  final String? lon;
  final String? windSpeed;
  final String? image;
  final String? humidity;
  final String? country;
  final String? clouds;
  final DateTime? sunrise;
  final DateTime? sunset;
  final String? temp;
  final int? weatherId;

  MockApiWeatherModel({
    this.id,
    this.cityName,
    this.lat,
    this.lon,
    this.windSpeed,
    this.image,
    this.humidity,
    this.country,
    this.clouds,
    this.sunrise,
    this.sunset,
    this.temp,
    this.weatherId,
  });

  MockApiWeatherModel copyWith({
    String? id,
    String? cityName,
    String? lat,
    String? lon,
    String? windSpeed,
    String? image,
    String? humidity,
    String? country,
    String? clouds,
    DateTime? sunrise,
    DateTime? sunset,
    String? temp,
    int? weatherId,
  }) =>
      MockApiWeatherModel(
        id: id ?? this.id,
        cityName: cityName ?? this.cityName,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        windSpeed: windSpeed ?? this.windSpeed,
        image: image ?? this.image,
        humidity: humidity ?? this.humidity,
        country: country ?? this.country,
        clouds: clouds ?? this.clouds,
        sunrise: sunrise ?? this.sunrise,
        sunset: sunset ?? this.sunset,
        temp: temp ?? this.temp,
        weatherId: weatherId ?? this.weatherId,
      );

  factory MockApiWeatherModel.fromJson(Map<String, dynamic> json) => MockApiWeatherModel(
    id: json["id"],
    cityName: json["cityName"],
    lat: json["lat"],
    lon: json["lon"],
    windSpeed: json["windSpeed"],
    image: json["image"],
    humidity: json["humidity"],
    country: json["country"],
    clouds: json["clouds"],
    sunrise: json["sunrise"] == null ? null : DateTime.parse(json["sunrise"]),
    sunset: json["sunset"] == null ? null : DateTime.parse(json["sunset"]),
    temp: json["temp"],
    weatherId: json["weatherId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cityName": cityName,
    "lat": lat,
    "lon": lon,
    "windSpeed": windSpeed,
    "image": image,
    "humidity": humidity,
    "country": country,
    "clouds": clouds,
    "sunrise": sunrise?.toIso8601String(),
    "sunset": sunset?.toIso8601String(),
    "temp": temp,
    "weatherId": weatherId,
  };
}
