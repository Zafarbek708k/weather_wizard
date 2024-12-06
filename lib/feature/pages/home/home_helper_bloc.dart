// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:weather_wizard/application/home_bloc/home_bloc.dart';
// import 'package:weather_wizard/domain/entity/my_weather_model.dart';
// import 'package:weather_wizard/domain/entity/weakly_weather_model.dart';
// import 'package:weather_wizard/domain/services/context_extension.dart';
// import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';
//
// import '../../widgets/custom_textfield.dart';
//
// class HomeHelperBloc extends StatefulWidget {
//   const HomeHelperBloc({super.key});
//
//   @override
//   State<HomeHelperBloc> createState() => _HomeHelperBlocState();
// }
//
// class _HomeHelperBlocState extends State<HomeHelperBloc> {
//   TextEditingController searchCtrl = TextEditingController();
//
//   @override
//   void dispose() {
//     searchCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return   Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: context.appTheme.primary,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: context.appTheme.primary,
//         title: CustomTextWidget(context.localized.home, color: context.appTheme.secondary, fontWeight: FontWeight.bold, fontSize: 20),
//         bottom: PreferredSize(preferredSize: MediaQuery.sizeOf(context) * 0.02, child: Divider(color: context.appTheme.surface)),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0),
//             child: CustomTF(controller: searchCtrl),
//           ),
//           const SizedBox(height: 10),
//           BlocBuilder<HomeBloc, HomeState>(
//             builder: (context, state){
//              if(state is HomeInitial){
//                return HomeInitialScreen(model: state.currentWeatherModel, elements: state.currentLocationWeeklyWeather);
//              }else if(state is HomeLoading){
//                return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
//              }else if(state is HomeWeatherLoaded){
//                return HomeLoadedScreen(model: state.weatherModel, elements: state.elements);
//              }else if(state is HomeError){
//                return Center(child: CustomTextWidget(state.message, color: Colors.red));
//              }else{
//                return const Center(child: CustomTextWidget("Nothing"));
//              }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class HomeInitialScreen extends StatelessWidget {
//   const HomeInitialScreen({super.key, required this.model, required this.elements});
//   final MyWeatherModel model;
//   final List<ListElement> elements;
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container();
//   }
// }
//
// class HomeLoadedScreen extends StatelessWidget {
//   const HomeLoadedScreen({super.key, required this.model, required this.elements});
//   final MyWeatherModel model;
//   final List<ListElement> elements;
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container();
//   }
// }
//
