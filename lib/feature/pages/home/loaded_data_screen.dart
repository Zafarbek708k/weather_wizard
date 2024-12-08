import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/entity/my_weather_model.dart';
import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';
import 'package:weather_wizard/domain/notwork_service/http_service.dart';
import 'package:weather_wizard/feature/widgets/my_weather_full_widget.dart';
import 'package:weather_wizard/feature/widgets/one_day_card_widget.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key, required this.model, required this.elements});

  final MyWeatherModel model;
  final List<ListElement> elements;

  Future<void> postData({required MyWeatherModel model}) async {
    String? result = await HttpClientService.post(api: HttpClientService.apiLocation, data: model.toJson());
    if (result != null) {
      log("Home post result: $result");
    } else {
      log("post func is not working");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: WeatherFullWidget(
              model: model,
              onPressed: () async {
                log("before post function : ${model.cityName}");
                await postData(model: model);
                log("post data next text ");
              },
            )),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                elements.length,
                (index) {
                  final element = elements[index];
                  return OneDayWidget(index: "${index + 1}", element: element);
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
