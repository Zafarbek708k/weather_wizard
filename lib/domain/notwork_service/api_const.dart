final class ApiConst {
  static const Duration connectionTimeout = Duration(minutes: 1);
  static const Duration sendTimeout = Duration(minutes: 1);
  static const Duration receiveTimeout = Duration(minutes: 1);
  static const String apiKey = "91599a67547034277dd51756b5166463";
  static const String baseUrl = "https://api.openweathermap.org";
  static const String apiWeather = "/data/2.5/weather";
  static const String apiGeoCode = "/geo/1.0/direct";
  static const String apiWeekly = "/data/2.5/forecast";

  String weather = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=e1a2a8fa9f04369204382ac76d5cdc4d&exclude=daily";
  //https://api.openweathermap.org/data/2.5/forecast/daily?lat=44.34&lon=10.99&cnt=7&appid=e1a2a8fa9f04369204382ac76d5cdc4
  //https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=91599a67547034277dd51756b5166463
  static const String geoCode = "http://api.openweathermap.org/geo/1.0/direct?q=Toshkent&limit=5&appid=91599a67547034277dd51756b5166463";




  static Map<String, String> geoCodeParam({required String city, int? limit}) => {"q": city, "limit": "${limit ?? 1}", "appid": ApiConst.apiKey};
  static Map<String, String> weatherParam({required String lat, required String long, String? units, String? lang, List<String>? exclude}) => {
        "lat": lat,
        "lon": long,
        "appid": apiKey,
        if (units != null) "units": units,
        if (lang != null) "lang": lang,
        if (exclude != null) "exclude": exclude.join(',')
      };
}
