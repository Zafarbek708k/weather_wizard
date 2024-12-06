import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/geo_code_model.dart';
import '../../domain/entity/my_weather_model.dart';
import '../../domain/entity/weakly_weather_model.dart';
import '../../domain/entity/weather_model.dart';
import '../../domain/notwork_service/api_const.dart';
import '../../domain/notwork_service/network_service.dart';
import '../../feature/pages/home/home.dart';

part 'home_event.dart';

part 'home_state.dart';

// Bloc for Weather and GeoCode
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // HomeBloc()
  //     : super(HomeInitial(
  //   currentWeatherModel: MyWeatherModel(
  //     temp: '',
  //     cityName: '',
  //     country: '',
  //     windSpeed: '',
  //     lat: '',
  //     lon: '',
  //     image: '',
  //     humidity: '',
  //     weatherId: 0,
  //     clouds: '',
  //     sunrise: '',
  //     sunset: '',
  //   ),
  //   currentLocationWeeklyWeather: initWeeklyWeatherFetchData,
  // )) {
  //   on<InitWeatherEvent>(_onInitWeatherEvent);
  //   on<GetWeatherEvent>(_onGetWeatherEvent);
  //   on<GetGeoCodeEvent>(_onGetGeoCodeEvent);
  // }
  HomeBloc() : super(HomeLoading()) {
    on<InitWeatherEvent>(_onInitWeatherEvent);
    on<GetWeatherEvent>(_onGetWeatherEvent);
    on<GetGeoCodeEvent>(_onGetGeoCodeEvent);

    // Fetch current location weather on initialization
    _initializeWeather();
  }

  Future<void> _initializeWeather() async {
    try {
      // Fetch user's current location
      Position position = await _determinePosition();
      // Fetch weather data for the location
      final currentWeather = await getWeatherFromLatLon(lat: "${position.latitude}", lon: "${position.longitude}");
      final weeklyWeather = await getWeeklyWeather(lat: "${position.latitude}", lon: "${position.longitude}");

      if (currentWeather != null && weeklyWeather.isNotEmpty) {
        emit(HomeInitial(currentWeatherModel: currentWeather, currentLocationWeeklyWeather: weeklyWeather));
      } else {
        emit(HomeError("Failed to load weather for the current location."));
      }
    } catch (e) {
      emit(HomeError("Failed to determine location or fetch weather: $e"));
    }
  }

  Future<void> pressFloatButton({required String cityName})async{
    emit(HomeLoading());
    final geoCode = await getGeoCode(cityName: cityName);
    if(geoCode != null){
      final oneDayModel = await getWeatherFromLatLon(lat: geoCode.lat, lon: geoCode.lon);
      final weeklyModel =  await getWeeklyWeather(lat: geoCode.lat, lon: geoCode.lon);
      if(oneDayModel != null && weeklyModel != null){
        emit(HomeWeatherLoaded(oneDayModel, weeklyModel));
      }else{
        emit(HomeError("Something went wring with $cityName, try again another city name."));
      }
    }else{
      emit(HomeError("Something went wring with $cityName, try again another city name."));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _onInitWeatherEvent(InitWeatherEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      Position position = await _determinePosition();
      final result = await getWeatherFromLatLon(lat: "${position.latitude}", lon: "${position.longitude}");
      final resultList = await getWeeklyWeather(lat: "${position.latitude}", lon: "${position.longitude}");
      if (result != null && resultList.isNotEmpty) {
        emit(HomeWeatherLoaded(result, resultList));
      } else {
        emit(HomeError("Failed to load weather data."));
      }
    } catch (e) {
      emit(HomeError("Failed to load data. Error: $e"));
    }
  }

  Future<void> _onGetWeatherEvent(GetWeatherEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final geoCode = await getGeoCode(cityName: event.cityName);
      if (geoCode != null) {
        final weatherModel = await getWeatherFromLatLon(lat: geoCode.lat, lon: geoCode.lon);
        final weeklyWeatherData = await getWeeklyWeather(lat: geoCode.lat, lon: geoCode.lon);
        if (weatherModel != null && weeklyWeatherData.isNotEmpty) {
          emit(HomeWeatherLoaded(weatherModel, weeklyWeatherData));
        } else {
          emit(HomeError("Failed to load weather data for ${event.cityName}."));
        }
      } else {
        emit(HomeError("Failed to fetch GeoCode for ${event.cityName} city"));
      }
    } catch (error) {
      emit(HomeError("Failed to fetch GeoCode for ${event.cityName} city \n Error: $error"));
    }
  }

  Future<void> _onGetGeoCodeEvent(GetGeoCodeEvent event, Emitter<HomeState> emit) async {}

  Future<MyWeatherModel?> getWeatherFromLatLon({required String lat, required String lon}) async {
    final String? result = await NetworkService.get(ApiConst.apiWeather, ApiConst.weatherParam(lat: lat, long: lon));
    if (result != null) {
      final weatherModel = weatherModelFromJson(result);

      int timezoneOffset = weatherModel.timezone!;

      DateTime sunriseUTC = DateTime.fromMillisecondsSinceEpoch(weatherModel.sys!.sunrise! * 1000, isUtc: true);
      DateTime sunsetUTC = DateTime.fromMillisecondsSinceEpoch(weatherModel.sys!.sunset! * 1000, isUtc: true);

      // Apply timezone offset
      DateTime sunriseLocal = sunriseUTC.add(Duration(seconds: timezoneOffset));
      DateTime sunsetLocal = sunsetUTC.add(Duration(seconds: timezoneOffset));
      String cityName = weatherModel.name!;
      String country = weatherModel.sys!.country!;
      String temp = "${(weatherModel.main!.temp! - 273.15).round()}";
      double windSpeed = weatherModel.wind!.speed!;
      double lat = weatherModel.coord!.lat!;
      double lon = weatherModel.coord!.lon!;
      double humidity = weatherModel.main!.humidity!.toDouble();
      int weatherId = weatherModel.weather![0].id!;
      int clouds = weatherModel.clouds!.all!;
      String image = "https://openweathermap.org/img/wn/${weatherModel.weather![0].icon}@2x.png";
      DateTime sunrise = sunriseLocal; // Local sunrise time
      DateTime sunset = sunsetLocal;

      final model = MyWeatherModel(
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
      return model;
    } else {
      return null;
    }
  }

  Future<List<ListElement>> getWeeklyWeather({required String lat, required String lon}) async {
    String? result = await NetworkService.get(ApiConst.apiWeekly, ApiConst.weatherParam(lat: lat, long: lon));
    if (result != null) {
      final listResult = weeklyWeatherModelFromJson(result);
      List<ListElement> list = listResult.list!;
      return list;
    } else {
      return [];
    }
  }

  Future<GeoCode?> getGeoCode({required String cityName}) async {
    String? result = await NetworkService.get(ApiConst.apiGeoCode, ApiConst.geoCodeParam(city: cityName));
    if (result != null) {
      final geoCodes = geoCodeModelFromJson(result);
      if (geoCodes.isNotEmpty) {
        return GeoCode(lat: geoCodes[0].lat.toString(), lon: geoCodes[0].lon.toString());
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
