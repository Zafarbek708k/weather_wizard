


import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class OneDayWidget extends StatelessWidget {
  const OneDayWidget({super.key, required this.index, required this.element});

  final String index;
  final ListElement element;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Colors.redAccent,
              Colors.deepOrange,
              Colors.deepOrange,
              Colors.orange,
              Colors.orangeAccent,
              Colors.yellow,
              Colors.yellowAccent,
              Colors.green,
              Colors.lightGreenAccent
            ],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: context.appTheme.primary),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.center, child: CustomTextWidget("Next $index day")),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 20,
                    child: Image.network("https://openweathermap.org/img/wn/${element.weather![0].icon}@2x.png"),
                  ),
                ),
                CustomTextWidget("${context.localized.temp}: ${(element.main!.temp! - 272).round()} ℃", fontSize: 10),
                CustomTextWidget("Description: ${element.weather![0].description}", fontSize: 10),
                CustomTextWidget("${context.localized.windSpeed}: ${element.wind!.speed}", fontSize: 10),
                CustomTextWidget("${context.localized.humidity}: ${element.main!.humidity}", fontSize: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}