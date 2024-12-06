import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_wizard/domain/entity/my_weather_model.dart';
import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';
import 'package:weather_wizard/domain/entity/weather_model.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';
import 'package:weather_wizard/feature/widgets/custom_textfield.dart';
import 'package:weather_wizard/feature/widgets/my_weather_full_widget.dart';
import 'package:weather_wizard/feature/widgets/one_day_card_widget.dart';

import '../../../application/home_bloc/home_bloc.dart';

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
  List<ListElement> weeks = [];
  bool isLoading = false;
  late WeatherModel? weatherModel;
  late MyWeatherModel myWeatherModel;

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Triggering InitWeatherEvent when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(InitWeatherEvent());
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.appTheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.appTheme.primary,
        title: CustomTextWidget(
          context.localized.home,
          color: context.appTheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        bottom: PreferredSize(
          preferredSize: MediaQuery.sizeOf(context) * 0.02,
          child: Divider(color: context.appTheme.surface),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent));
          } else if (state is HomeWeatherLoaded) {
            final myWeatherModel = state.weatherModel;
            return ListView(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: CustomTF(controller: searchCtrl),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: WeatherFullWidget(
                    model: myWeatherModel,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                // SizedBox(
                //   height: 150,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: List.generate(
                //       weeks.length,
                //           (index) {
                //         final element = weeks[index];
                //         return OneDayWidget(index: "${index + 1}", element: element);
                //       },
                //     ),
                //   ),
                // ),
              ],
            );
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: context.appTheme.error, fontSize: 18),
              ),
            );
          } else {
            return ListView(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: CustomTF(controller: searchCtrl),
                ),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appTheme.outline,
        onPressed: () {
          final searchText = searchCtrl.text.trim();
          if (searchText.isNotEmpty) {
            context.read<HomeBloc>().add(GetWeatherEvent(cityName: searchText));
          } else {
            searchCtrl.clear();
          }
        },
        child: const Icon(Icons.search),
      ),
    );
  }

}
