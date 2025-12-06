// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class ThemeController extends GetxController {
//   final GetStorage _box = GetStorage();

//   final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
//   ThemeMode get themeMode => _themeMode.value;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadTheme();
//   }

//   void _loadTheme() {
//     final savedTheme = _box.read('themeMode');
//     if (savedTheme != null) {
//       _themeMode.value = ThemeMode.values[savedTheme];
//     }
//   }

//   void toggleTheme() {
//     _themeMode.value = _themeMode.value == ThemeMode.light
//         ? ThemeMode.dark
//         : ThemeMode.light;

//     _box.write('themeMode', _themeMode.value.index);
//   }

//   bool get isDarkMode => _themeMode.value == ThemeMode.dark;
// }
