
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_wizard/application/favorite_bloc/favorite_bloc.dart';
import 'package:weather_wizard/domain/entity/mock_api_weather_model.dart';
import 'package:weather_wizard/feature/pages/favorite/saved_locations.dart';

class LoadedDataScreen extends StatelessWidget {
  const LoadedDataScreen({super.key, required this.items});

  final List<MockApiWeatherModel> items;

  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        ...List.generate(
          items.length,
              (index) {
            final model = items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SavedLocations(
                model: model,
                onPressed: () async {
                  await context.read<FavoriteBloc>().deleteLocation(id: model.id!);
                },
              ),
            );
          },
        )
      ],
    )
        : Center(child: SvgPicture.asset("assets/svg/empty-man.svg"));
  }
}
