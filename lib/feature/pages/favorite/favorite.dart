import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_wizard/application/favorite_bloc/favorite_bloc.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/pages/favorite/loaded_data_screen.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
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
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteInitial) {
            return LoadedDataScreen(items: state.items);
          } else if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            return LoadedDataScreen(items: state.items);
          } else if (state is FavoriteError) {
            return Center(child: CustomTextWidget(state.msg, color: Colors.red));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appTheme.outline,
        onPressed: () async {
          await context.read<FavoriteBloc>().initGetLocation();
        },
        child: Icon(Icons.refresh_outlined, color: context.appTheme.secondary),
      ),
    );
  }
}



// body: Center(
//   child: Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 18.0),
//     child: items.isEmpty
//         ? Center(child: SvgPicture.asset("assets/svg/empty-man.svg"))
//         : ListView(
//             children: [
//               ...List.generate(
//                 items.length,
//                 (index) {
//                   final model = items[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10.0),
//                     child: SavedLocations(
//                       model: model,
//                       onPressed: () async {
//                         // await deleteData(id: model.id!);
//                       },
//                     ),
//                   );
//                 },
//               )
//             ],
//           ),
//   ),
// ),