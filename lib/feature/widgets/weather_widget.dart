import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/entity/weather_model.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherModel model;

  const WeatherWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepOrangeAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              model.weather![0].main ?? "null main",
              color: context.appTheme.secondary,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${model.weather![0].icon}@2x.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextWidget(
                    model.weather![0].description ?? "description",
                    color: context.appTheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Text(
            //   'Temperature: ${weather.temperature.toStringAsFixed(1)}°C',
            //   style: Theme.of(context).textTheme.bodyText1,
            // ),
            // Text(
            //   'Feels Like: ${weather.feelsLike.toStringAsFixed(1)}°C',
            //   style: Theme.of(context).textTheme.bodyText2,
            // ),
            // Text(
            //   'Humidity: ${weather.humidity}%',
            //   style: Theme.of(context).textTheme.bodyText2,
            // ),
            CustomTextWidget(
              'Wind Speed: ${model.wind!.speed ?? 0} m/s',
              color: context.appTheme.secondary,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Sunrise: ${_formatTime(weather.sunrise)}',
                    //   style: Theme.of(context).textTheme.caption,
                    // ),
                    Text(
                      'Sunset: ${_formatTime(model.sys!.sunset ?? 0)}',
                    ),
                  ],
                ),
                // Text(
                //   weather.country,
                //   style: Theme.of(context).textTheme.bodyText2,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}