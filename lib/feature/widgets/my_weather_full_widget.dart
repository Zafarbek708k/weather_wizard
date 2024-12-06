import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/entity/my_weather_model.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class WeatherFullWidget extends StatelessWidget {
  WeatherFullWidget({super.key, required this.model, required this.onPressed});

  final VoidCallback onPressed;

  final MyWeatherModel model;
  String weathermodel = "";

  void findWeatherStatus(int weatherId) {
    switch (weatherId) {
      // Thunderstorm (200–299)
      case 200:
        weathermodel = "Yengil yomg‘ir bilan momoqaldiroq";
        break;
      case 201:
        weathermodel = "O‘rta yomg‘ir bilan momoqaldiroq";
        break;
      case 202:
        weathermodel = "Kuchli yomg‘ir bilan momoqaldiroq";
        break;
      case 210:
        weathermodel = "Yengil momoqaldiroq";
        break;
      case 211:
        weathermodel = "Oddiy momoqaldiroq";
        break;
      case 212:
        weathermodel = "Kuchli momoqaldiroq";
        break;
      case 221:
        weathermodel = "O‘zgaruvchan momoqaldiroq";
        break;
      case 230:
        weathermodel = "Yengil momoqaldiroq va mayda yomg‘ir";
        break;
      case 231:
        weathermodel = "O‘rta momoqaldiroq va yomg‘ir";
        break;
      case 232:
        weathermodel = "Kuchli momoqaldiroq va yomg‘ir";
        break;

      // Drizzle (300–399)
      case 300:
        weathermodel = "Yengil chakka yomg‘ir";
        break;
      case 301:
        weathermodel = "Chakka yomg‘ir";
        break;
      case 302:
        weathermodel = "Kuchli chakka yomg‘ir";
        break;
      case 310:
        weathermodel = "Yengil chakka yomg‘ir va yomg‘ir";
        break;
      case 311:
        weathermodel = "O‘rta yomg‘ir";
        break;
      case 312:
        weathermodel = "Kuchli yomg‘ir";
        break;
      case 313:
        weathermodel = "Chakka yomg‘ir va yomg‘ir";
        break;
      case 314:
        weathermodel = "Juda kuchli yomg‘ir";
        break;
      case 321:
        weathermodel = "Yomg‘ir tomchilari";
        break;

      // Rain (500–599)
      case 500:
        weathermodel = "Yengil yomg‘ir";
        break;
      case 501:
        weathermodel = "O‘rta yomg‘ir";
        break;
      case 502:
        weathermodel = "Kuchli yomg‘ir";
        break;
      case 503:
        weathermodel = "Juda kuchli yomg‘ir";
        break;
      case 504:
        weathermodel = "Ekstremal yomg‘ir";
        break;
      case 511:
        weathermodel = "Qattiq yomg‘ir va muz";
        break;
      case 520:
        weathermodel = "Yengil yomg‘ir va momoqaldiroq";
        break;
      case 521:
        weathermodel = "O‘rta yomg‘ir va momoqaldiroq";
        break;
      case 522:
        weathermodel = "Kuchli yomg‘ir va momoqaldiroq";
        break;
      case 531:
        weathermodel = "To‘satdan kuchayadigan yomg‘ir";
        break;

      // Snow (600–699)
      case 600:
        weathermodel = "Yengil qor";
        break;
      case 601:
        weathermodel = "O‘rta qor";
        break;
      case 602:
        weathermodel = "Kuchli qor";
        break;
      case 611:
        weathermodel = "Qor va yomg‘ir aralash";
        break;
      case 612:
        weathermodel = "Kuchli qor va yomg‘ir aralash";
        break;
      case 613:
        weathermodel = "Qor va momoqaldiroq aralash";
        break;
      case 615:
        weathermodel = "Yengil qor va yomg‘ir";
        break;
      case 616:
        weathermodel = "O‘rta qor va yomg‘ir";
        break;
      case 620:
        weathermodel = "Yengil qor va momoqaldiroq";
        break;
      case 621:
        weathermodel = "O‘rta qor va momoqaldiroq";
        break;
      case 622:
        weathermodel = "Kuchli qor va momoqaldiroq";
        break;

      // Atmosphere (700–799)
      case 701:
        weathermodel = "Tuman";
        break;
      case 711:
        weathermodel = "Tutun";
        break;
      case 721:
        weathermodel = "Pushti";
        break;
      case 731:
        weathermodel = "Quvurlar va chang";
        break;
      case 741:
        weathermodel = "Tuman";
        break;
      case 751:
        weathermodel = "Quvurlar";
        break;
      case 761:
        weathermodel = "Chang";
        break;
      case 762:
        weathermodel = "Yong‘in tutuni";
        break;
      case 771:
        weathermodel = "Shiddatli shamol";
        break;
      case 781:
        weathermodel = "Tornado";
        break;

      // Clear sky (800)
      case 800:
        weathermodel = "Ochiq osmon";
        break;

      // Clouds (801–804)
      case 801:
        weathermodel = "Kam bulutli";
        break;
      case 802:
        weathermodel = "O‘rta bulutli";
        break;
      case 803:
        weathermodel = "Ko‘p bulutli";
        break;
      case 804:
        weathermodel = "Juda bulutli";
        break;

      // Default case for unhandled IDs
      default:
        weathermodel = "Noma'lum ob-havo holati";
    }

    // Log or print the result for debugging
    print('Ob-havo holati: $weathermodel');
  }

  @override
  Widget build(BuildContext context) {
    findWeatherStatus(model.weatherId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Colors.yellowAccent, Colors.greenAccent, Colors.orangeAccent, Colors.deepOrangeAccent, Colors.redAccent],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: context.appTheme.primary),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget("${context.localized.country}: ${model.country}", fontSize: 12),
                      CustomTextWidget(
                        "${context.localized.city}: ${model.cityName} ",
                        fontSize: 12,
                      ),
                    ],
                  ),
                  SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Image.network(model.image),
                          ),
                          CustomTextWidget("${context.localized.temp}: ${model.temp} ℃")
                        ],
                      )),
                  CustomTextWidget("${context.localized.weather}: $weathermodel"),
                  CustomTextWidget("${context.localized.lat}: ${model.lat}"),
                  CustomTextWidget("${context.localized.lon}: ${model.lon}"),
                  CustomTextWidget("${context.localized.windSpeed}: ${model.windSpeed} m/s"),
                  CustomTextWidget("${context.localized.humidity}: ${model.humidity} 💧"),
                  CustomTextWidget("${context.localized.sunrise}: ${model.sunrise.substring(0, 19)}"),
                  CustomTextWidget("${context.localized.sunset}: ${model.sunset.substring(0, 19)}"),
                ],
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
          child: const CustomTextWidget("Save Location", color: Colors.lightGreenAccent,fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
