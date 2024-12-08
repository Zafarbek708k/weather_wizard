part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}

class GetFavoriteLocationsEvent extends FavoriteEvent{}

class DeleteFavoriteLocationEvent extends FavoriteEvent{
  final String id;
  DeleteFavoriteLocationEvent({required this.id});
}

