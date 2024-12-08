import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_wizard/domain/entity/mock_api_weather_model.dart';
import 'package:weather_wizard/domain/notwork_service/http_service.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/pages/favorite/saved_locations.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<MockApiWeatherModel> items = [];
  bool isLoading = false;

  Future<void> getData() async {
    isLoading = false;
    String? result = await HttpClientService.getData(api: HttpClientService.apiLocation);
    if (result != null) {
      isLoading = true;
      List<MockApiWeatherModel> list = mockApiWeatherModelFromJson(result);
      items = list;
      setState(() {});
    } else {
      items = [];
      setState(() {
        isLoading = true;
      });
    }
    setState(() {

    });
  }

  Future<void> deleteData({required String id}) async {
    String? result = await HttpClientService.deleteData(api: HttpClientService.apiLocation, id: id);
    if (result != null) {
      await getData();
      setState(() {});
    }else{
      setState(() {

      });
    }
    setState(() {

    });
  }


  @override
  void didChangeDependencies() async {
    await getData().then((value){
      setState(() {});
    });
    super.didChangeDependencies();
  }

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
                        final model = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: SavedLocations(
                            model: model,
                            onPressed: () async {
                              await deleteData(id: model.id!);
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appTheme.outline,
        onPressed: () async {
          await getData();
        },
        child:  Icon(Icons.refresh_outlined, color: context.appTheme.secondary),
      ),
    );
  }
}
