import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/entity/mock_api_weather_model.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class SavedLocations extends StatelessWidget {
  const SavedLocations({super.key, required this.model, required this.onPressed});

  final MockApiWeatherModel model;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Colors.red,
                Colors.redAccent,
                Colors.deepOrange,
                Colors.deepOrangeAccent,
                Colors.orange,
                Colors.yellow,
                Colors.yellowAccent,
                Colors.green,
                Colors.lightGreenAccent
              ],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.appTheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomTextWidget(model.country!, color: context.appTheme.secondary),
                        CustomTextWidget(model.cityName!, color: context.appTheme.secondary),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget("${context.localized.temp}: ${model.temp} ℃"),
                            CustomTextWidget("${context.localized.humidity}: ${model.humidity}", fontSize: 10),
                            CustomTextWidget("${context.localized.windSpeed}: ${model.windSpeed} m/s", fontSize: 10),
                            CustomTextWidget("${context.localized.sunrise}: ${(model.sunrise).toString().substring(0, 19)}", fontSize: 10),
                            CustomTextWidget("${context.localized.sunset}: ${(model.sunset).toString().substring(0, 19)} ", fontSize: 10),
                          ],
                        ),
                        SizedBox(width: 60, child: Image.network(model.image!))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        MaterialButton(
          onPressed: onPressed,
          minWidth: double.infinity,
          height: 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: context.appTheme.outline)),
          child: Center(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomTextWidget("Delete", color: Colors.red),
              const SizedBox(width: 10),
              Icon(Icons.delete_outline, color: context.appTheme.secondary)
            ],
          )),
        )
      ],
    );
  }
}
