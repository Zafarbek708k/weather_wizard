part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeWeatherLoaded extends HomeState {
  final MyWeatherModel weatherModel;
  final List<ListElement> elements;

  HomeWeatherLoaded(this.weatherModel, this.elements);
}

class HomeGeoCodeLoaded extends HomeState {
  final GeoCode geoCode;
  HomeGeoCodeLoaded(this.geoCode);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
