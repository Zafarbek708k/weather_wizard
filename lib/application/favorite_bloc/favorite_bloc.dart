import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/mock_api_weather_model.dart';
import '../../domain/notwork_service/http_service.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteLoading()) {
    on<GetFavoriteLocationsEvent>(_getAllLocation);
    on<DeleteFavoriteLocationEvent>(_deleteLocation);
    initGetLocation();
  }

  Future<void> _getAllLocation(GetFavoriteLocationsEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoading());
      String? result = await HttpClientService.getData(api: HttpClientService.apiLocation);
      if (result != null) {
        List<MockApiWeatherModel> list = mockApiWeatherModelFromJson(result);
        emit(FavoriteLoaded(items: list));
      } else {
        emit(FavoriteError(msg: "Something went wring at get List Weather"));
      }
    } catch (e) {
      emit(FavoriteError(msg: "Something went wring at get List Weather\n Error: $e"));
    }
  }

  Future<void> _deleteLocation(DeleteFavoriteLocationEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoading());
      String? result = await HttpClientService.deleteData(api: HttpClientService.apiLocation, id: event.id);
      if (result != null) {
        emit(FavoriteLoading());
        String? result = await HttpClientService.getData(api: HttpClientService.apiLocation);
        if (result != null) {
          List<MockApiWeatherModel> list = mockApiWeatherModelFromJson(result);
          emit(FavoriteLoaded(items: list));
        } else {
          emit(FavoriteError(msg: "Something went wring at get List Weather"));
        }
      } else {
        emit(FavoriteError(msg: "Something went wring at delete item Weather"));
      }
    } catch (error) {
      emit(FavoriteError(msg: "Something went wring at delete item Weather\n Error: $error"));
    }
  }

  Future<void> initGetLocation() async {
    try {
      emit(FavoriteLoading());
      String? result = await HttpClientService.getData(api: HttpClientService.apiLocation);
      if (result != null) {
        List<MockApiWeatherModel> list = mockApiWeatherModelFromJson(result);
        emit(FavoriteLoaded(items: list));
      } else {
        emit(FavoriteError(msg: "Something went wring at get List Weather"));
      }
    } catch (e) {
      emit(FavoriteError(msg: "Something went wring at get List Weather\n Error: $e"));
    }
  }

  Future<void> deleteLocation({required String id})async{
    try {
      emit(FavoriteLoading());
      String? result = await HttpClientService.deleteData(api: HttpClientService.apiLocation, id: id);
      if (result != null) {
        emit(FavoriteLoading());
        String? result = await HttpClientService.getData(api: HttpClientService.apiLocation);
        if (result != null) {
          List<MockApiWeatherModel> list = mockApiWeatherModelFromJson(result);
          emit(FavoriteLoaded(items: list));
        } else {
          emit(FavoriteError(msg: "Something went wring at get List Weather"));
        }
      } else {
        emit(FavoriteError(msg: "Something went wring at delete item Weather"));
      }
    } catch (error) {
      emit(FavoriteError(msg: "Something went wring at delete item Weather\n Error: $error"));
    }
  }
}
