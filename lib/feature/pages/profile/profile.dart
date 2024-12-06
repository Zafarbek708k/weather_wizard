import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';
import 'package:weather_wizard/feature/widgets/custom_text_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.appTheme.primary,
        title: CustomTextWidget(context.localized.profile, color: context.appTheme.secondary, fontWeight: FontWeight.bold,fontSize: 20),
        bottom: PreferredSize(preferredSize: MediaQuery.sizeOf(context) * 0.02, child: Divider(color: context.appTheme.surface)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage("https://i.pinimg.com/736x/82/26/96/822696099c99ecca6054821746001a8b.jpg"),
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomTextWidget("Founder: ",color: context.appTheme.secondary),
                  CustomTextWidget("Zafarbek Karimov", color: Colors.blueAccent),
                ],
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomTextWidget("Telegram: ",color: context.appTheme.secondary),
                  CustomTextWidget("@MrKarimov_708k", color: Colors.blueAccent),
                ],
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomTextWidget("Phone: ",color: context.appTheme.secondary),
                  CustomTextWidget("+998 (97) 625 29 79", color: Colors.blueAccent),
                ],
              ),


              ],
          ),
        ),
      ),
    );
  }
}
