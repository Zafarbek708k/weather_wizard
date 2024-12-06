


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';

class CustomTF extends StatelessWidget {
  const CustomTF({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        labelText: ' ${context.localized.search} ',
        hintText: ' ${context.localized.cityName} ',
        hintStyle: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        labelStyle:  const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 20),
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade700)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.black)),
      ),
    );
  }
}