import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_wizard/domain/entity/my_weather_model.dart';
import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';
import 'package:weather_wizard/feature/widgets/custom_textfield.dart';
import 'package:weather_wizard/feature/widgets/my_weather_full_widget.dart';
import '../../../application/home_bloc/home_bloc.dart';
import '../../widgets/one_day_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class GeoCode {
  String lat, lon;

  GeoCode({required this.lat, required this.lon});
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.appTheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.appTheme.primary,
        title: CustomTextWidget(context.localized.home, color: context.appTheme.secondary, fontWeight: FontWeight.bold, fontSize: 20),
        bottom: PreferredSize(preferredSize: MediaQuery.sizeOf(context) * 0.02, child: Divider(color: context.appTheme.surface)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: CustomTF(controller: searchCtrl),
          ),
          const SizedBox(height: 10),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state){
              if(state is HomeInitial){
                return DataScreen(model: state.currentWeatherModel, elements: state.currentLocationWeeklyWeather);
              }else if(state is HomeLoading){
                return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
              }else if(state is HomeWeatherLoaded){
                return DataScreen(model: state.weatherModel, elements: state.elements);
              }else if(state is HomeError){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Center(child: CustomTextWidget(state.message, color: Colors.red)),
                );
              }else{
                return const Center(child: CustomTextWidget("Nothing"));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appTheme.outline,
        onPressed: () async {
          if (searchCtrl.text.isNotEmpty) {
           await context.read<HomeBloc>().pressFloatButton(cityName: searchCtrl.text);
          } else {
            searchCtrl.clear();
          }
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}


class DataScreen extends StatelessWidget {
  const DataScreen({super.key, required this.model, required this.elements});
  final MyWeatherModel model;
  final List<ListElement> elements;

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
            onPressed: () {},
          ),
        ),
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
        SizedBox(height: 10)
      ],
    );
  }
}


