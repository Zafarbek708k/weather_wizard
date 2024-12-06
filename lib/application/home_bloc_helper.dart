import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_wizard/application/home_bloc/home_bloc.dart';
import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';

import '../domain/entity/my_weather_model.dart';
import '../feature/pages/home/home.dart';

class HomeBlocHelper extends Bloc<HomeEvent, HomeState> {
  HomeBlocHelper() : super(HomeInitial()) {
    on<InitWeatherEvent>(_onInitWeatherEvent);
    on<GetWeatherEvent>(_onGetWeatherEvent);
    on<GetGeoCodeEvent>(_onGetGeoCodeEvent);
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
    try{
      final geoCode = await getGeoCode(cityName: event.cityName);
      if(geoCode != null){
        final weatherModel = await getWeatherFromLatLon(lat: geoCode.lat, lon: geoCode.lon);
        final weeklyWeatherData = await getWeeklyWeather(lat: geoCode.lat, lon: geoCode.lon);
        if(weatherModel != null && weeklyWeatherData.isNotEmpty){
          emit(HomeWeatherLoaded(weatherModel, weeklyWeatherData));
        }else{
          emit(HomeError("Failed to load weather data for ${event.cityName}."));
        }
      }else{
        emit(HomeError("Failed to fetch GeoCode for ${event.cityName} city"));
      }
    }catch(error){
      emit(HomeError("Failed to fetch GeoCode for ${event.cityName} city \n Error: $error"));
    }
  }

  Future<void> _onGetGeoCodeEvent(GetGeoCodeEvent event, Emitter<HomeState> emit) async {}


  Future<MyWeatherModel?> getWeatherFromLatLon({required String lat, required String lon}) async {
    return null;
  }

  Future<List<ListElement>> getWeeklyWeather({required String lat, required String lon}) async {
    return [];
  }

  Future<GeoCode?>getGeoCode({required String cityName})async{
    return null;
  }
}
