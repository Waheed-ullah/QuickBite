// import 'package:get/get.dart';
// import 'package:quickbite/data/repository/local_storage.dart';
// import 'package:quickbite/data/repository/restaurant_repository.dart';
// import 'package:quickbite/modules/cart/controllers/cart_controller.dart';
// import 'package:quickbite/modules/restaurants/controllers/restaurant_controller.dart';

// class AppBinding implements Bindings {
//   @override
//   void dependencies() {
//     // Initialize LocalStorage with async put
//     Get.putAsync<LocalStorage>(() async {
//       final storage = LocalStorage();
//       await storage.init();
//       return storage;
//     }, permanent: true);

//     // Initialize RestaurantRepository
//     Get.put(RestaurantRepository(), permanent: true);

//     // Initialize CartController
//     Get.put(CartController(), permanent: true);

//     // Initialize RestaurantController (but don't auto-create)
//     // We'll use Get.lazyPut with fenix: true so it's created when needed
//     Get.lazyPut(() => RestaurantController(), fenix: true);
//   }
// }
