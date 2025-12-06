import 'package:get/get.dart';
import 'package:quickbite/data/models/order_model.dart';

class OrderController extends GetxController {
  final RxList<Order> _orders = <Order>[].obs;

  List<Order> get orders => _orders;

  Future<void> placeOrder(Order order) async {
    // In production, this would call an API
    // For prototype, just add to local list
    _orders.insert(0, order);

    // Save to local storage
    await _saveOrdersToCache();
  }

  Future<void> _saveOrdersToCache() async {
    // Implementation depends on storage method
    // Convert orders to JSON and save
  }

  Future<void> loadOrdersFromCache() async {
    // Load orders from local storage
  }
}
