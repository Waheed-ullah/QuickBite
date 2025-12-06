import 'package:get/get.dart';
import 'package:quickbite/common/controllers/network_controller.dart';
import 'package:quickbite/common/controllers/theme_controller.dart';
import 'package:quickbite/data/repository/cart_repository.dart';
import 'package:quickbite/data/repository/local_storage.dart';
import 'package:quickbite/data/repository/restaurant_repository.dart';
import 'package:quickbite/data/repository/order_repository.dart';
import 'package:quickbite/modules/cart/controllers/cart_controller.dart';
import 'package:quickbite/modules/orders/controllers/order_controller.dart';
import 'package:quickbite/modules/restaurants/controllers/restaurant_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut(() => LocalStorage(), fenix: true);
    // Get.lazyPut(() => NetworkController(), fenix: true);
    // Get.lazyPut(() => ThemeController(), fenix: true);

    // Repositories
    Get.lazyPut(() => RestaurantRepository(), fenix: true);
    Get.lazyPut(() => CartRepository(), fenix: true);
    Get.lazyPut(() => OrderRepository(), fenix: true);

    // Controllers
    Get.lazyPut(() => RestaurantController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
  }
}
