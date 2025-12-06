import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage extends GetxService {
  late Box _box;
  late Box _ordersBox;

  Future<LocalStorage> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('quickbite_cache');
    _ordersBox = await Hive.openBox('quickbite_orders');
    return this;
  }

  // Restaurant data caching
  Future<void> cacheRestaurants(String jsonString) async {
    await _box.put('restaurants_data', jsonString);
    await _box.put(
      'restaurants_last_updated',
      DateTime.now().toIso8601String(),
    );
  }

  String? getCachedRestaurants() {
    return _box.get('restaurants_data');
  }

  bool hasRestaurantsCache() {
    return _box.containsKey('restaurants_data');
  }

  DateTime? getRestaurantsCacheTime() {
    final timeString = _box.get('restaurants_last_updated');
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }

  // Cart data caching
  Future<void> cacheCart(List<Map<String, dynamic>> cartData) async {
    await _box.put('cart_data', cartData);
    await _box.put('cart_last_updated', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>>? getCachedCart() {
    return _box.get('cart_data');
  }

  bool hasCartCache() {
    return _box.containsKey('cart_data');
  }

  // Order data caching
  Future<void> cacheOrders(List<Map<String, dynamic>> ordersData) async {
    await _ordersBox.put('orders_data', ordersData);
    await _ordersBox.put(
      'orders_last_updated',
      DateTime.now().toIso8601String(),
    );
  }

  List<Map<String, dynamic>>? getCachedOrders() {
    return _ordersBox.get('orders_data');
  }

  bool hasOrdersCache() {
    return _ordersBox.containsKey('orders_data');
  }

  DateTime? getOrdersCacheTime() {
    final timeString = _ordersBox.get('orders_last_updated');
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }

  // Promo codes caching
  Future<void> cachePromoCodes(List<Map<String, dynamic>> promoCodes) async {
    await _box.put('promo_codes', promoCodes);
  }

  List<Map<String, dynamic>>? getCachedPromoCodes() {
    return _box.get('promo_codes');
  }

  // User preferences
  Future<void> saveUserPreference(String key, dynamic value) async {
    await _box.put(key, value);
  }

  dynamic getUserPreference(String key) {
    return _box.get(key);
  }

  // Clear specific cache
  Future<void> clearCache(String key) async {
    await _box.delete(key);
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    await _box.clear();
    await _ordersBox.clear();
  }

  // Check if cache is still valid
  bool isCacheValid(
    String lastUpdatedKey, {
    Duration maxAge = const Duration(hours: 1),
  }) {
    final timeString = _box.get(lastUpdatedKey);
    if (timeString == null) return false;

    final cacheTime = DateTime.parse(timeString);
    return DateTime.now().difference(cacheTime) < maxAge;
  }
}
