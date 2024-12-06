import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_wizard/domain/entity/my_weather_model.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<MyWeatherModel> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.appTheme.primary,
        title: CustomTextWidget(context.localized.favorite, color: context.appTheme.secondary, fontWeight: FontWeight.bold, fontSize: 20),
        bottom: PreferredSize(preferredSize: MediaQuery.sizeOf(context) * 0.02, child: Divider(color: context.appTheme.surface)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: items.isEmpty
              ? Center(child: SvgPicture.asset("assets/svg/empty-man.svg"))
              : ListView(
                  children: [
                    ...List.generate(
                      items.length,
                      (index) {
                        return Card(
                          child: ListTile(
                            onTap: () {},
                            title: CustomTextWidget("$index"),
                          ),
                        );
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
