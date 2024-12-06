part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {
  final MyWeatherModel currentWeatherModel;
  final List<ListElement> currentLocationWeeklyWeather;
  HomeInitial({required this.currentWeatherModel, required this.currentLocationWeeklyWeather});
}

class HomeLoading extends HomeState {}

class HomeWeatherLoaded extends HomeState {
  final MyWeatherModel weatherModel;
  final List<ListElement> elements;

  HomeWeatherLoaded(this.weatherModel, this.elements);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
