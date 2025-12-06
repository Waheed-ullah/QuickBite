import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickbite/common/utils/app_binding.dart';
import 'package:quickbite/data/repository/local_storage.dart';
import 'package:quickbite/res/app_routes.dart';
import 'package:quickbite/res/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters (if using Hive TypeAdapters)
  // Hive.registerAdapter(RestaurantAdapter());
  // Hive.registerAdapter(MenuItemAdapter());
  // Hive.registerAdapter(CartItemAdapter());
  // Hive.registerAdapter(OrderAdapter());

  // Initialize Local Storage
  final localStorage = LocalStorage();
  await localStorage.init();

  // Put LocalStorage in GetX for dependency injection
  Get.put(localStorage, permanent: true);

  runApp(const QuickBiteApp());
}

class QuickBiteApp extends StatelessWidget {
  const QuickBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QuickBite',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.restaurants,
      getPages: AppRoutes.pages,
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
