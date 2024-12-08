part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {
  final List<MockApiWeatherModel> items;

  FavoriteInitial({required this.items});
}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<MockApiWeatherModel> items;

  FavoriteLoaded({required this.items});
}

final class FavoriteError extends FavoriteState {
  final String msg;

  FavoriteError({required this.msg});
}
