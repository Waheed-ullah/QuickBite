import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickbite/data/repository/local_storage.dart';
import 'package:quickbite/data/repository/restaurant_repository.dart';
import 'package:quickbite/modules/cart/controllers/cart_controller.dart';
import 'package:quickbite/modules/orders/controllers/order_controller.dart';
import 'package:quickbite/modules/restaurants/controllers/restaurant_controller.dart';
import 'package:quickbite/res/app_routes.dart';
import 'package:quickbite/res/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final localStorage = LocalStorage();
  await localStorage.init();
  Get.put(localStorage, permanent: true);

  Get.put(RestaurantRepository(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(RestaurantController(), permanent: true);
  Get.put(OrderController(), permanent: true);

  runApp(const QuickBiteApp());
}

class QuickBiteApp extends StatelessWidget {
  const QuickBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QuickBite',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.restaurants,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
