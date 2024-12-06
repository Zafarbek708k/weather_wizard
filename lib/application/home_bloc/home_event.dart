part of 'home_bloc.dart';


abstract class HomeEvent {}

class InitWeatherEvent extends HomeEvent {}

class GetWeatherEvent extends HomeEvent {
  final String cityName;

  GetWeatherEvent({required this.cityName});
}

class GetGeoCodeEvent extends HomeEvent {
  final String cityName;

  GetGeoCodeEvent({required this.cityName});
}

