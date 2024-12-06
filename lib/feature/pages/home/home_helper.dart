import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/entity/geo_code_model.dart';
import 'package:weather_wizard/domain/entity/my_weather_model.dart';
import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';
import 'package:weather_wizard/domain/entity/weather_model.dart';
import 'package:weather_wizard/domain/notwork_service/api_const.dart';
import 'package:weather_wizard/domain/notwork_service/network_service.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';
import 'package:weather_wizard/feature/widgets/custom_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_wizard/feature/widgets/my_weather_full_widget.dart';
import 'package:weather_wizard/feature/widgets/one_day_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class GeoCode {
  String lat, lon;

  GeoCode({required this.lat, required this.lon});
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchCtrl = TextEditingController();
  List<ListElement> weeks = [];
  bool isLoading = false;
  late WeatherModel? weatherModel;
  late MyWeatherModel myWeatherModel;

  Future<GeoCode?> getGeoCode({required String city}) async {
    late GeoCode geoCode;
    List<GeoCodeModel> list = [];
    String? result = await NetworkService.get(ApiConst.apiGeoCode, ApiConst.geoCodeParam(city: city));
    if (result != null) {
      list = geoCodeModelFromJson(result);
      geoCode = GeoCode(lat: list[0].lat.toString(), lon: list[0].lon.toString());
      return geoCode;
    } else {
      return null;
    }
  }

  Future<MyWeatherModel?> getWeatherData({required String cityName}) async {
    weeks = [];
    isLoading = false;
    await Timer(const Duration(seconds: 2), () {});
    GeoCode? geoCode = await getGeoCode(city: cityName);
    if (geoCode!.lat.length > 4 && geoCode.lon.length > 3) {
      String? result = await NetworkService.get(ApiConst.apiWeather, ApiConst.weatherParam(lat: geoCode.lat, long: geoCode.lon));
      if (result != null) {
        weatherModel = weatherModelFromJson(result);
        int timezoneOffset = weatherModel!.timezone!;

        DateTime sunriseUTC = DateTime.fromMillisecondsSinceEpoch(weatherModel!.sys!.sunrise! * 1000, isUtc: true);
        DateTime sunsetUTC = DateTime.fromMillisecondsSinceEpoch(weatherModel!.sys!.sunset! * 1000, isUtc: true);

        // Apply timezone offset
        DateTime sunriseLocal = sunriseUTC.add(Duration(seconds: timezoneOffset));
        DateTime sunsetLocal = sunsetUTC.add(Duration(seconds: timezoneOffset));
        String cityName = weatherModel!.name!;
        String country = weatherModel!.sys!.country!;
        String temp = "${(weatherModel!.main!.temp! - 273.15).round()}";
        double windSpeed = weatherModel!.wind!.speed!;
        double lat = weatherModel!.coord!.lat!;
        double lon = weatherModel!.coord!.lon!;
        double humidity = weatherModel!.main!.humidity!.toDouble();
        int weatherId = weatherModel!.weather![0].id!;
        int clouds = weatherModel!.clouds!.all!;
        String image = "https://openweathermap.org/img/wn/${weatherModel!.weather![0].icon}@2x.png";
        DateTime sunrise = sunriseLocal; // Local sunrise time
        DateTime sunset = sunsetLocal; // Local sunset time
        await getOneWeekData(lat: "$lat", long: "$lon");
        setState(() {});
        isLoading = true;
        myWeatherModel = MyWeatherModel(
            temp: temp,
            cityName: cityName,
            country: country,
            windSpeed: "$windSpeed",
            lat: "$lat",
            lon: "$lon",
            image: image,
            humidity: "$humidity",
            weatherId: weatherId,
            clouds: "$clouds",
            sunset: "$sunset",
            sunrise: "$sunrise");
        isLoading = true;
        setState(() {});
        return myWeatherModel;
      } else {
        isLoading = true;
        return null;
      }
    }
    setState(() {});
    return null;
  }

  Future<void> getOneWeekData({required String lat, required String long}) async {
    String? result = await NetworkService.get(ApiConst.apiWeekly, ApiConst.weatherParam(lat: lat, long: long));
    if (result != null) {
      final value = weeklyWeatherModelFromJson(result);
      weeks = value.list!;
    } else {
      log("weekly data is empty");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<MyWeatherModel?> init() async {
    isLoading = false;
    setState(() {});
    Position value = await _determinePosition();
    log("Lat: ${value.latitude} Lang: ${value.longitude}");
    String? result = await NetworkService.get(ApiConst.apiWeather, ApiConst.weatherParam(lat: "${value.latitude}", long: "${value.longitude}"));
    log("init result $result");
    if (result != null) {
      weatherModel = weatherModelFromJson(result);
      int timezoneOffset = weatherModel!.timezone!;

      DateTime sunriseUTC = DateTime.fromMillisecondsSinceEpoch(weatherModel!.sys!.sunrise! * 1000, isUtc: true);
      DateTime sunsetUTC = DateTime.fromMillisecondsSinceEpoch(weatherModel!.sys!.sunset! * 1000, isUtc: true);

      // Apply timezone offset
      DateTime sunriseLocal = sunriseUTC.add(Duration(seconds: timezoneOffset));
      DateTime sunsetLocal = sunsetUTC.add(Duration(seconds: timezoneOffset));
      String cityName = weatherModel!.name!;
      String country = weatherModel!.sys!.country!;
      String temp = "${(weatherModel!.main!.temp! - 273.15).round()}";
      double windSpeed = weatherModel!.wind!.speed!;
      double lat = weatherModel!.coord!.lat!;
      double lon = weatherModel!.coord!.lon!;
      double humidity = weatherModel!.main!.humidity!.toDouble();
      int weatherId = weatherModel!.weather![0].id!;
      int clouds = weatherModel!.clouds!.all!;
      String image = "https://openweathermap.org/img/wn/${weatherModel!.weather![0].icon}@2x.png";
      DateTime sunrise = sunriseLocal; // Local sunrise time
      DateTime sunset = sunsetLocal; // Local sunset time

      await getOneWeekData(lat: "$lat", long: "$lon");
      setState(() {});
      myWeatherModel = MyWeatherModel(
          temp: temp,
          cityName: cityName,
          country: country,
          windSpeed: "$windSpeed",
          lat: "$lat",
          lon: "$lon",
          image: image,
          humidity: "$humidity",
          weatherId: weatherId,
          clouds: "$clouds",
          sunset: "$sunset",
          sunrise: "$sunrise");
      isLoading = true;
      setState(() {});
      return myWeatherModel;
    } else {
      isLoading = true;
      setState(() {});
      return null;
    }
  }

  @override
  void didChangeDependencies() async {
    await init();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.appTheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.appTheme.primary,
        title: CustomTextWidget(context.localized.home, color: context.appTheme.secondary, fontWeight: FontWeight.bold, fontSize: 20),
        bottom: PreferredSize(preferredSize: MediaQuery.sizeOf(context) * 0.02, child: Divider(color: context.appTheme.surface)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: CustomTF(controller: searchCtrl),
          ),
          const SizedBox(height: 10),
          isLoading && myWeatherModel != null
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: WeatherFullWidget(
              model: myWeatherModel,
              onPressed: () {},
            ),
          )
              : const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent)),
          const SizedBox(height: 10),
          isLoading
              ? SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(
                  7,
                      (index) {
                    final element = weeks[index];
                    return OneDayWidget(index: "${index + 1}", element: element);
                  },
                )
              ],
            ),
          )
              : const SizedBox.shrink()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appTheme.outline,
        onPressed: () async {
          if (searchCtrl.text.isNotEmpty) {
            await getWeatherData(cityName: searchCtrl.text);
          } else {
            searchCtrl.clear();
          }
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}