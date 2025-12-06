import 'package:get/get.dart';
import 'package:quickbite/data/models/restaurant_model.dart';
import 'package:quickbite/data/repository/restaurant_repository.dart';
import 'package:quickbite/data/repository/local_storage.dart';

class RestaurantController extends GetxController {
  final RestaurantRepository _repository = Get.find();
  final LocalStorage _localStorage = Get.find();

  RxList<Restaurant> restaurants = <Restaurant>[].obs;
  RxBool isLoading = true.obs;
  RxString error = ''.obs;
  RxBool isOfflineMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      isLoading(true);
      error('');

      // Try to load from cache first
      if (_localStorage.hasRestaurantsCache()) {
        isOfflineMode(true);
        // Parse cached data
        // Implementation for parsing cached data
      }

      // Load fresh data
      final freshData = await _repository.getRestaurants();
      restaurants.assignAll(freshData);

      // Cache the data
      // _localStorage.cacheRestaurants(json.encode(freshData));

      isOfflineMode(false);
    } catch (e) {
      error(e.toString());
      // Fallback to cache if available
      if (_localStorage.hasRestaurantsCache()) {
        isOfflineMode(true);
        // Load from cache
      }
    } finally {
      isLoading(false);
    }
  }

  void toggleFavorite(String restaurantId) {
    final index = restaurants.indexWhere((r) => r.id == restaurantId);
    if (index != -1) {
      restaurants[index].isFavorite = !restaurants[index].isFavorite;
      restaurants.refresh();
    }
  }

  Restaurant? getRestaurantById(String id) {
    return restaurants.firstWhereOrNull((r) => r.id == id);
  }
}
