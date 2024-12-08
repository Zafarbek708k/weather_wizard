import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_wizard/domain/entity/my_weather_model.dart';
import 'package:weather_wizard/domain/notwork_service/http_service.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/pages/home/loaded_data_screen.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';
import 'package:weather_wizard/feature/widgets/custom_textfield.dart';
import '../../../application/home_bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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




