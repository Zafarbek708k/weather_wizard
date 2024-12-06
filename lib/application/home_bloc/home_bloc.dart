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
  HomeBloc() : super(HomeInitial()) {
    on<InitWeatherEvent>(_onInitWeatherEvent);
    on<GetWeatherEvent>(_onGetWeatherEvent);
    on<GetGeoCodeEvent>(_onGetGeoCodeEvent);
  }

  /// init get location and weather and use permission

  // Helper: Determine user position
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

  /// init
  // Initialize weather data on app start
  Future<void> _onInitWeatherEvent(InitWeatherEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final Position position = await _determinePosition();
      final MyWeatherModel? weatherModel = await _fetchWeatherFromPosition(lat: "${position.latitude}", lon: "${position.longitude}");

      if (weatherModel != null) {
        emit(HomeWeatherLoaded(weatherModel, []));
      } else {
        emit(HomeError("Failed to load weather data."));
      }
    } catch (e) {
      emit(HomeError("Error: ${e.toString()}"));
    }
  }

  // Helper: Fetch weather data
  Future<MyWeatherModel?> _fetchWeatherFromPosition({required String lat, required String lon}) async {
    final String? result = await NetworkService.get(ApiConst.apiWeather, ApiConst.weatherParam(lat: lat, long: lon));
    final String? resultWeekData = await NetworkService.get(ApiConst.apiWeekly, ApiConst.weatherParam(lat: lat, long: lon));

    if (result != null && resultWeekData != null) {
      final WeatherModel weatherModel = weatherModelFromJson(result);

      return MyWeatherModel(
        temp: "${(weatherModel.main!.temp! - 273.15).round()}",
        cityName: weatherModel.name!,
        country: weatherModel.sys!.country!,
        windSpeed: "${weatherModel.wind!.speed!}",
        lat: lat,
        lon: lon,
        image: "https://openweathermap.org/img/wn/${weatherModel.weather![0].icon}@2x.png",
        humidity: "${weatherModel.main!.humidity}",
        weatherId: weatherModel.weather![0].id!,
        clouds: "${weatherModel.clouds!.all}",
        sunrise: "${weatherModel.sys!.sunrise!}",
        sunset: "${weatherModel.sys!.sunset!}",
      );
    }
    return null;
  }

  // Fetch weather data for a given city
  Future<void> _onGetWeatherEvent(GetWeatherEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final GeoCode? geoCode = await _getGeoCode(city: event.cityName);
      if (geoCode != null) {
        final MyWeatherModel? weatherModel = await _fetchWeatherFromPosition(lat: geoCode.lat, lon: geoCode.lon);

        if (weatherModel != null) {
          emit(HomeWeatherLoaded(weatherModel, []));
        } else {
          emit(HomeError("Failed to load weather data for ${event.cityName}."));
        }
      } else {
        emit(HomeError("Invalid city name: ${event.cityName}."));
      }
    } catch (e) {
      emit(HomeError("Error: ${e.toString()}"));
    }
  }

  // Fetch GeoCode for a given city
  Future<void> _onGetGeoCodeEvent(GetGeoCodeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final GeoCode? geoCode = await _getGeoCode(city: event.cityName);
      if (geoCode != null) {
        emit(HomeGeoCodeLoaded(geoCode));
      } else {
        emit(HomeError("Failed to fetch geocode for ${event.cityName}."));
      }
    } catch (e) {
      emit(HomeError("Error: ${e.toString()}"));
    }
  }

  Future<GeoCode?> _getGeoCode({required String city}) async {
    final String? result = await NetworkService.get(
      ApiConst.apiGeoCode,
      ApiConst.geoCodeParam(city: city),
    );

    if (result != null) {
      final List<GeoCodeModel> geoCodes = geoCodeModelFromJson(result);
      if (geoCodes.isNotEmpty) {
        return GeoCode(lat: geoCodes[0].lat.toString(), lon: geoCodes[0].lon.toString());
      }
    }
    return null;
  }
}
