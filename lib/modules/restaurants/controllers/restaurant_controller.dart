import 'dart:convert';

import 'package:get/get.dart';
import 'package:quickbite/data/models/restaurant_model.dart';
import 'package:quickbite/data/repository/restaurant_repository.dart';
import 'package:quickbite/data/repository/local_storage.dart';

class RestaurantController extends GetxController {
  RxList<Restaurant> restaurants = <Restaurant>[].obs;
  RxList<Restaurant> filteredRestaurants = <Restaurant>[].obs;
  RxBool isLoading = true.obs;
  RxString error = ''.obs;

  RxString searchQuery = ''.obs;
  RxString sortBy = 'rating'.obs;
  RxList<String> selectedCuisines = <String>[].obs;
  RxBool showFavoritesOnly = false.obs;
  late RestaurantRepository _repository;
  late LocalStorage _localStorage;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<RestaurantRepository>();
    _localStorage = Get.find<LocalStorage>();
    loadRestaurants();
    loadPreferences();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadPreferences() async {
    sortBy.value = _localStorage.getPreference('sort_by', 'rating');

    final savedPromoCode = _localStorage.getPromoCode();
    if (savedPromoCode != null && savedPromoCode.isNotEmpty) {}
  }

  Future<void> loadRestaurants() async {
    try {
      isLoading(true);
      error('');

      if (_localStorage.hasRestaurantsCache()) {
        final cachedData = _localStorage.getCachedRestaurants();
        if (cachedData != null) {
          try {
            final parsedData = await _parseRestaurantsFromJson(cachedData);
            if (parsedData.isNotEmpty) {
              restaurants.assignAll(parsedData);
              await _loadFavorites();
              applyFilters();
              isLoading(false);
              return;
            }
          } catch (e) {
            print('Error parsing cached data: $e');
          }
        }
      }

      final freshData = await _repository.getRestaurants();
      restaurants.assignAll(freshData);

      await _cacheRestaurantsData(freshData);

      await _loadFavorites();

      applyFilters();
    } catch (e) {
      error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to load restaurants: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<List<Restaurant>> _parseRestaurantsFromJson(String jsonData) async {
    try {
      final jsonMap = jsonDecode(jsonData);
      final restaurantsList = jsonMap['restaurants'] as List;

      return restaurantsList.map((item) {
        return Restaurant.fromJson(item);
      }).toList();
    } catch (e) {
      print('Error parsing JSON: $e');
      return [];
    }
  }

  Future<void> _cacheRestaurantsData(List<Restaurant> restaurantsList) async {
    try {
      final restaurantsJson = {
        'restaurants': restaurantsList.map((r) => r.toJson()).toList(),
      };
      final jsonString = jsonEncode(restaurantsJson);
      await _localStorage.cacheRestaurants(jsonString);
    } catch (e) {
      print('Error caching restaurants: $e');
    }
  }

  Future<void> _loadFavorites() async {
    final favoriteIds = _localStorage.getFavoriteRestaurants();

    for (var i = 0; i < restaurants.length; i++) {
      final restaurant = restaurants[i];
      if (favoriteIds.contains(restaurant.id)) {
        restaurants[i] = restaurant.copyWith(isFavorite: true);
      }
    }

    restaurants.refresh();
  }

  void toggleFavorite(String restaurantId) {
    final index = restaurants.indexWhere((r) => r.id == restaurantId);
    if (index != -1) {
      final isFavorite = !restaurants[index].isFavorite;
      restaurants[index] = restaurants[index].copyWith(isFavorite: isFavorite);
      restaurants.refresh();

      _localStorage.toggleFavorite(restaurantId);

      applyFilters();
    }
  }

  Restaurant? getRestaurantById(String id) {
    return restaurants.firstWhereOrNull((r) => r.id == id);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query.trim();
    applyFilters();
  }

  void clearSearch() {
    searchQuery.value = '';
    applyFilters();
  }

  void setSortBy(String value) {
    sortBy.value = value;
    _localStorage.savePreference('sort_by', value);
    applyFilters();
  }

  void toggleCuisineFilter(String cuisine) {
    if (selectedCuisines.contains(cuisine)) {
      selectedCuisines.remove(cuisine);
    } else {
      selectedCuisines.add(cuisine);
    }
    applyFilters();
  }

  void toggleFavoritesFilter() {
    showFavoritesOnly.value = !showFavoritesOnly.value;
    applyFilters();
  }

  void clearAllFilters() {
    searchQuery.value = '';
    selectedCuisines.clear();
    showFavoritesOnly.value = false;
    applyFilters();
  }

  void applyFilters() {
    if (restaurants.isEmpty) {
      filteredRestaurants.clear();
      return;
    }

    List<Restaurant> filtered = List.from(restaurants);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query) ||
            restaurant.cuisine.toLowerCase().contains(query) ||
            restaurant.zone.toLowerCase().contains(query);
      }).toList();
    }

    if (selectedCuisines.isNotEmpty) {
      filtered = filtered.where((restaurant) {
        return selectedCuisines.contains(restaurant.cuisine);
      }).toList();
    }

    if (showFavoritesOnly.value) {
      filtered = filtered.where((restaurant) => restaurant.isFavorite).toList();
    }

    filtered.sort((a, b) {
      switch (sortBy.value) {
        case 'name':
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case 'rating':
          return b.rating.compareTo(a.rating);
        case 'deliveryFee':
          return _getDeliveryFee(a.zone).compareTo(_getDeliveryFee(b.zone));
        default:
          return 0;
      }
    });

    filteredRestaurants.assignAll(filtered);
  }

  double _getDeliveryFee(String zone) {
    switch (zone) {
      case 'Urban':
        return 20;
      case 'Suburban':
        return 30;
      case 'Remote':
        return 50;
      default:
        return 30;
    }
  }

  List<String> getAvailableCuisines() {
    if (restaurants.isEmpty) return [];

    final cuisines = restaurants.map((r) => r.cuisine).toSet().toList();
    cuisines.sort();
    return cuisines;
  }

  List<String> getAvailableZones() {
    if (restaurants.isEmpty) return [];

    final zones = restaurants.map((r) => r.zone).toSet().toList();
    zones.sort();
    return zones;
  }

  List<Restaurant> getRestaurantsByCuisine(String cuisine) {
    return restaurants.where((r) => r.cuisine == cuisine).toList();
  }

  List getTopRatedRestaurants({int limit = 5}) {
    final sorted = List.from(restaurants)
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return sorted.take(limit).toList();
  }

  bool get areFiltersActive {
    return searchQuery.isNotEmpty ||
        selectedCuisines.isNotEmpty ||
        showFavoritesOnly.value;
  }

  int get activeFilterCount {
    int count = 0;
    if (searchQuery.isNotEmpty) count++;
    if (selectedCuisines.isNotEmpty) count++;
    if (showFavoritesOnly.value) count++;
    return count;
  }

  Future<void> refreshData() async {
    await loadRestaurants();
  }

  void addToSearchHistory(String query) {
    if (query.trim().isEmpty) return;

    final history = _localStorage.getSearchHistory();
    history.remove(query);
    history.insert(0, query);
    if (history.length > 10) {
      history.removeLast();
    }

    _localStorage.saveSearchHistory(history);
  }

  List<String> getSearchHistory() {
    return _localStorage.getSearchHistory();
  }

  void clearSearchHistory() {
    _localStorage.saveSearchHistory([]);
  }

  String getDeliveryFeeText(Restaurant restaurant) {
    final fee = _getDeliveryFee(restaurant.zone);
    return '₹${fee.toInt()}';
  }

  String getDeliveryTimeEstimate(Restaurant restaurant) {
    switch (restaurant.zone) {
      case 'Urban':
        return '20-30 mins';
      case 'Suburban':
        return '30-45 mins';
      case 'Remote':
        return '45-60 mins';
      default:
        return '30-45 mins';
    }
  }

  bool isRestaurantOpen(Restaurant restaurant) {
    return true;
  }

  Map<String, dynamic> getRestaurantStats() {
    if (restaurants.isEmpty) {
      return {'total': 0, 'avgRating': 0.0, 'cuisineCount': 0, 'zoneCount': 0};
    }

    final cuisines = restaurants.map((r) => r.cuisine).toSet();
    final zones = restaurants.map((r) => r.zone).toSet();
    final avgRating =
        restaurants.map((r) => r.rating).reduce((a, b) => a + b) /
        restaurants.length;

    return {
      'total': restaurants.length,
      'avgRating': double.parse(avgRating.toStringAsFixed(1)),
      'cuisineCount': cuisines.length,
      'zoneCount': zones.length,
    };
  }

  int get filteredCount => filteredRestaurants.length;

  bool get noResultsAfterFilter {
    return !isLoading.value &&
        filteredRestaurants.isEmpty &&
        restaurants.isNotEmpty;
  }

  String get emptyStateMessage {
    if (isLoading.value) return 'Loading...';
    if (restaurants.isEmpty) return 'No restaurants available';
    if (filteredRestaurants.isEmpty && areFiltersActive) {
      return 'No restaurants match your filters';
    }
    return 'No restaurants found';
  }

  String get emptyStateIcon {
    if (restaurants.isEmpty) return '😞';
    if (filteredRestaurants.isEmpty && areFiltersActive) {
      return '🔍';
    }
    return '📋';
  }
}
