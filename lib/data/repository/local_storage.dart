import 'package:hive/hive.dart';
import 'package:get/get.dart';

class LocalStorage extends GetxService {
  late Box _appBox;
  late Box _cartBox;
  late Box _favoritesBox;

  Future<LocalStorage> init() async {
    _appBox = await Hive.openBox('app_settings');
    _cartBox = await Hive.openBox('cart_data');
    _favoritesBox = await Hive.openBox('favorites');
    return this;
  }

  // ========== CART METHODS ==========
  Future<void> saveCart(List<Map<String, dynamic>> cartItems) async {
    await _cartBox.put('cart_items', cartItems);
  }

  List<Map<String, dynamic>> getCart() {
    return _cartBox.get('cart_items', defaultValue: []);
  }

  Future<void> saveCartItem(Map<String, dynamic> cartItem) async {
    final String key = '${cartItem['restaurantId']}_${cartItem['menuItemId']}';
    await _cartBox.put(key, cartItem);
  }

  List<Map<String, dynamic>> getCartItems() {
    // Get individual cart items
    final individualItems = _cartBox.values
        .where((value) => value is Map<String, dynamic>)
        .where(
          (item) => item['restaurantId'] != null && item['menuItemId'] != null,
        )
        .map((item) => item as Map<String, dynamic>)
        .toList();

    // Get bulk cart items
    final bulkItems = _cartBox.get('cart_items', defaultValue: []);

    return [...individualItems, ...bulkItems];
  }

  Future<void> removeCartItem(String restaurantId, String menuItemId) async {
    final String key = '${restaurantId}_$menuItemId';
    await _cartBox.delete(key);
  }

  Future<void> updateCartQuantity(
    String restaurantId,
    String menuItemId,
    int quantity,
  ) async {
    final String key = '${restaurantId}_$menuItemId';
    final cartItem = _cartBox.get(key);
    if (cartItem != null) {
      cartItem['quantity'] = quantity;
      await _cartBox.put(key, cartItem);
    }
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
  }

  // ========== FAVORITE METHODS ==========
  Future<void> toggleFavorite(String restaurantId) async {
    final isFavorite = _favoritesBox.get(restaurantId, defaultValue: false);
    await _favoritesBox.put(restaurantId, !isFavorite);
  }

  bool isFavorite(String restaurantId) {
    return _favoritesBox.get(restaurantId, defaultValue: false);
  }

  List<String> getFavoriteRestaurants() {
    return _favoritesBox.keys
        .where((key) => _favoritesBox.get(key) == true)
        .map((e) => e.toString())
        .toList();
  }

  // ========== ORDERS METHODS ==========
  Future<void> saveOrders(List<Map<String, dynamic>> orders) async {
    await _appBox.put('orders', orders);
  }

  List<Map<String, dynamic>> getOrders() {
    return _appBox.get('orders', defaultValue: []);
  }

  // ========== APP SETTINGS & PREFERENCES ==========
  Future<void> savePreference(String key, dynamic value) async {
    await _appBox.put(key, value);
  }

  dynamic getPreference(String key, [dynamic defaultValue]) {
    return _appBox.get(key, defaultValue: defaultValue);
  }

  Future<void> savePromoCode(String code) async {
    await _appBox.put('promo_code', code);
  }

  String? getPromoCode() {
    return _appBox.get('promo_code');
  }

  Future<void> saveSearchHistory(List<String> history) async {
    await _appBox.put('search_history', history);
  }

  List<String> getSearchHistory() {
    return _appBox.get('search_history', defaultValue: []);
  }

  Future<void> saveSortPreference(String sortBy) async {
    await _appBox.put('sort_by', sortBy);
  }

  String getSortPreference() {
    return _appBox.get('sort_by', defaultValue: 'rating');
  }

  Future<void> saveRestaurantsData(String jsonData) async {
    await _appBox.put('restaurants_data', jsonData);
  }

  String? getRestaurantsData() {
    return _appBox.get('restaurants_data');
  }

  bool hasRestaurantsCache() {
    return _appBox.containsKey('restaurants_data');
  }

  // ========== RESTAURANT CACHE ==========
  Future<void> cacheRestaurants(String jsonData) async {
    await saveRestaurantsData(jsonData);
    await _appBox.put(
      'restaurants_last_updated',
      DateTime.now().toIso8601String(),
    );
  }

  String? getCachedRestaurants() {
    return getRestaurantsData();
  }

  DateTime? getRestaurantsCacheTime() {
    final timeString = _appBox.get('restaurants_last_updated');
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }

  // ========== ORDER CACHE ==========
  Future<void> cacheOrders(List<Map<String, dynamic>> orders) async {
    await saveOrders(orders);
    await _appBox.put('orders_last_updated', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>> getCachedOrders() {
    return getOrders();
  }

  // ========== CART CACHE ==========
  Future<void> cacheCart(List<Map<String, dynamic>> cartItems) async {
    await saveCart(cartItems);
    await _cartBox.put('cart_last_updated', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>> getCachedCart() {
    return getCart();
  }

  bool hasCartCache() {
    return _cartBox.containsKey('cart_items') ||
        _cartBox.values.any(
          (value) =>
              value is Map<String, dynamic> && value['restaurantId'] != null,
        );
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    await _appBox.clear();
    await _cartBox.clear();
    await _favoritesBox.clear();
  }
}
