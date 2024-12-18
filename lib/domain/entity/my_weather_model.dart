class MyWeatherModel {
  String cityName, lat, lon, windSpeed, image, humidity, country, clouds, sunrise, sunset, temp;
  int weatherId;

  MyWeatherModel({
    required this.cityName,
    required this.country,
    required this.windSpeed,
    required this.lat,
    required this.lon,
    required this.image,
    required this.humidity,
    required this.weatherId,
    required this.clouds,
    required this.sunset,
    required this.temp,
    required this.sunrise,
  });

  Map<String, dynamic> toJson() {
    return {
      "cityName": cityName,
      "lat": lat,
      "lon": lon,
      "windSpeed": windSpeed,
      "image": image,
      "humidity": humidity,
      "country": country,
      "clouds": clouds,
      "sunrise": sunrise,
      "sunset": sunset,
      "temp": temp,
      "weatherId": weatherId,
    };
  }

}
