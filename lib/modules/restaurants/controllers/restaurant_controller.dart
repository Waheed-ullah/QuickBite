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

  // Search & Filter Properties
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

    // Load saved promo code if any
    final savedPromoCode = _localStorage.getPromoCode();
    if (savedPromoCode != null && savedPromoCode.isNotEmpty) {
      // You might want to pass this to CartController
    }
  }

  Future<void> loadRestaurants() async {
    try {
      isLoading(true);
      error('');

      // Check cache first
      if (_localStorage.hasRestaurantsCache()) {
        // Load from cache if available
        final cachedData = _localStorage.getCachedRestaurants();
        if (cachedData != null) {
          try {
            // Parse cached JSON data
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

      // Load fresh data
      final freshData = await _repository.getRestaurants();
      restaurants.assignAll(freshData);

      // Cache the data for offline use
      await _cacheRestaurantsData(freshData);

      // Load favorites from storage
      await _loadFavorites();

      // Apply initial filter
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

    // Update restaurant favorite status
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

      // Save to storage
      _localStorage.toggleFavorite(restaurantId);

      // Update filtered list
      applyFilters();
    }
  }

  Restaurant? getRestaurantById(String id) {
    return restaurants.firstWhereOrNull((r) => r.id == id);
  }

  // ========== SEARCH & FILTER METHODS ==========

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

    // 1. Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query) ||
            restaurant.cuisine.toLowerCase().contains(query) ||
            restaurant.zone.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Apply cuisine filter
    if (selectedCuisines.isNotEmpty) {
      filtered = filtered.where((restaurant) {
        return selectedCuisines.contains(restaurant.cuisine);
      }).toList();
    }

    // 3. Apply favorites filter
    if (showFavoritesOnly.value) {
      filtered = filtered.where((restaurant) => restaurant.isFavorite).toList();
    }

    // 4. Apply sorting
    filtered.sort((a, b) {
      switch (sortBy.value) {
        case 'name':
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case 'rating':
          return b.rating.compareTo(a.rating); // Descending
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

  // Get restaurants by cuisine
  List<Restaurant> getRestaurantsByCuisine(String cuisine) {
    return restaurants.where((r) => r.cuisine == cuisine).toList();
  }

  // Get top rated restaurants
  List getTopRatedRestaurants({int limit = 5}) {
    final sorted = List.from(restaurants)
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return sorted.take(limit).toList();
  }

  // Check if any filters are active
  bool get areFiltersActive {
    return searchQuery.isNotEmpty ||
        selectedCuisines.isNotEmpty ||
        showFavoritesOnly.value;
  }

  // Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (searchQuery.isNotEmpty) count++;
    if (selectedCuisines.isNotEmpty) count++;
    if (showFavoritesOnly.value) count++;
    return count;
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadRestaurants();
  }

  // Add to search history
  void addToSearchHistory(String query) {
    if (query.trim().isEmpty) return;

    final history = _localStorage.getSearchHistory();
    // Remove if already exists
    history.remove(query);
    // Add to beginning
    history.insert(0, query);
    // Keep only last 10 searches
    if (history.length > 10) {
      history.removeLast();
    }

    _localStorage.saveSearchHistory(history);
  }

  // Get search history
  List<String> getSearchHistory() {
    return _localStorage.getSearchHistory();
  }

  // Clear search history
  void clearSearchHistory() {
    _localStorage.saveSearchHistory([]);
  }

  // Get delivery fee for restaurant
  String getDeliveryFeeText(Restaurant restaurant) {
    final fee = _getDeliveryFee(restaurant.zone);
    return '₹${fee.toInt()}';
  }

  // Get delivery time estimate
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

  // Check if restaurant is open (simplified - always true for prototype)
  bool isRestaurantOpen(Restaurant restaurant) {
    return true; // In real app, check opening hours
  }

  // Get restaurant stats
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

  // Get filtered restaurant count
  int get filteredCount => filteredRestaurants.length;

  // Check if no results after filtering
  bool get noResultsAfterFilter {
    return !isLoading.value &&
        filteredRestaurants.isEmpty &&
        restaurants.isNotEmpty;
  }

  // Get message for empty state
  String get emptyStateMessage {
    if (isLoading.value) return 'Loading...';
    if (restaurants.isEmpty) return 'No restaurants available';
    if (filteredRestaurants.isEmpty && areFiltersActive) {
      return 'No restaurants match your filters';
    }
    return 'No restaurants found';
  }

  // Get icon for empty state
  String get emptyStateIcon {
    if (restaurants.isEmpty) return '😞';
    if (filteredRestaurants.isEmpty && areFiltersActive) {
      return '🔍';
    }
    return '📋';
  }
}
