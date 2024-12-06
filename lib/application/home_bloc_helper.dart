// import 'package:bloc/bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:weather_wizard/application/home_bloc/home_bloc.dart';
// import 'package:weather_wizard/domain/entity/geo_code_model.dart';
// import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';
// import 'package:weather_wizard/domain/entity/weather_model.dart';
// import 'package:weather_wizard/domain/notwork_service/api_const.dart';
// import 'package:weather_wizard/domain/notwork_service/network_service.dart';
//
// import '../domain/entity/my_weather_model.dart';
// import '../feature/pages/home/home.dart';
//
// class HomeBlocHelper extends Bloc<HomeEvent, HomeState> {
//   HomeBlocHelper() : super(HomeInitial()) {
//     on<InitWeatherEvent>(_onInitWeatherEvent);
//     on<GetWeatherEvent>(_onGetWeatherEvent);
//     on<GetGeoCodeEvent>(_onGetGeoCodeEvent);
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) throw Exception('Location services are disabled.');
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   Future<void> _onInitWeatherEvent(InitWeatherEvent event, Emitter<HomeState> emit) async {
//     emit(HomeLoading());
//     try {
//       Position position = await _determinePosition();
//       final result = await getWeatherFromLatLon(lat: "${position.latitude}", lon: "${position.longitude}");
//       final resultList = await getWeeklyWeather(lat: "${position.latitude}", lon: "${position.longitude}");
//       if (result != null && resultList.isNotEmpty) {
//         emit(HomeWeatherLoaded(result, resultList));
//       } else {
//         emit(HomeError("Failed to load weather data."));
//       }
//     } catch (e) {
//       emit(HomeError("Failed to load data. Error: $e"));
//     }
//   }
//
//   Future<void> _onGetWeatherEvent(GetWeatherEvent event, Emitter<HomeState> emit) async {
//     emit(HomeLoading());
//     try{
//       final geoCode = await getGeoCode(cityName: event.cityName);
//       if(geoCode != null){
//         final weatherModel = await getWeatherFromLatLon(lat: geoCode.lat, lon: geoCode.lon);
//         final weeklyWeatherData = await getWeeklyWeather(lat: geoCode.lat, lon: geoCode.lon);
//         if(weatherModel != null && weeklyWeatherData.isNotEmpty){
//           emit(HomeWeatherLoaded(weatherModel, weeklyWeatherData));
//         }else{
//           emit(HomeError("Failed to load weather data for ${event.cityName}."));
//         }
//       }else{
//         emit(HomeError("Failed to fetch GeoCode for ${event.cityName} city"));
//       }
//     }catch(error){
//       emit(HomeError("Failed to fetch GeoCode for ${event.cityName} city \n Error: $error"));
//     }
//   }
//
//   Future<void> _onGetGeoCodeEvent(GetGeoCodeEvent event, Emitter<HomeState> emit) async {}
//
//
//   Future<MyWeatherModel?> getWeatherFromLatLon({required String lat, required String lon}) async {
//     final String? result = await NetworkService.get(ApiConst.apiWeather, ApiConst.weatherParam(lat: lat, long: lon));
//     if(result != null){
//       final weatherModel = weatherModelFromJson(result);
//       MyWeatherModel model =  MyWeatherModel(
//         temp: "${(weatherModel.main!.temp! - 273.15).round()}",
//         cityName: weatherModel.name!,
//         country: weatherModel.sys!.country!,
//         windSpeed: "${weatherModel.wind!.speed!}",
//         lat: lat,
//         lon: lon,
//         image: "https://openweathermap.org/img/wn/${weatherModel.weather![0].icon}@2x.png",
//         humidity: "${weatherModel.main!.humidity}",
//         weatherId: weatherModel.weather![0].id!,
//         clouds: "${weatherModel.clouds!.all}",
//         sunrise: "${weatherModel.sys!.sunrise!}",
//         sunset: "${weatherModel.sys!.sunset!}",
//       );
//       return model;
//     }else {
//       return null;
//     }
//   }
//
//   Future<List<ListElement>> getWeeklyWeather({required String lat, required String lon}) async {
//     String? result = await NetworkService.get(ApiConst.apiWeekly, ApiConst.weatherParam(lat: lat, long: lon));
//     if(result != null){
//       final listResult = weeklyWeatherModelFromJson(result);
//       List<ListElement> list = listResult.list!;
//       return list;
//     }else{
//       return [];
//     }
//   }
//
//   Future<GeoCode?>getGeoCode({required String cityName})async{
//     String? result = await NetworkService.get(ApiConst.apiGeoCode, ApiConst.geoCodeParam(city: cityName));
//     if(result != null){
//       final geoCodes = geoCodeModelFromJson(result);
//       if(geoCodes.isNotEmpty){
//         return GeoCode(lat: geoCodes[0].lat.toString(), lon: geoCodes[0].lon.toString());
//       }else{
//         return null;
//       }
//     }else{
//       return null;
//     }
//   }
// }
