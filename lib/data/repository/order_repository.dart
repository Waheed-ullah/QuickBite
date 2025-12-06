import 'package:get/get.dart';
import 'package:quickbite/data/models/order_model.dart';
import 'package:quickbite/data/repository/local_storage.dart';

class OrderRepository extends GetxService {
  final LocalStorage _localStorage = Get.find();

  Future<void> saveOrder(Order order) async {
    try {
      // Get existing orders
      final existingOrders = _localStorage.getCachedOrders();
      final updatedOrders = List<Map<String, dynamic>>.from(existingOrders)
        ..insert(0, order.toJson());

      // Save to storage
      await _localStorage.cacheOrders(updatedOrders);
    } catch (e) {
      throw Exception('Failed to save order: $e');
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final ordersData = _localStorage.getCachedOrders();
      return ordersData.map((data) => Order.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final orders = await getOrders();
      return orders.firstWhereOrNull((order) => order.id == orderId);
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }

  bool hasOrders() {
    final orders = _localStorage.getCachedOrders();
    return orders.isNotEmpty;
  }

  // For demo purposes - generate a unique order ID
  String generateOrderId() {
    final now = DateTime.now();
    return 'ORD${now.millisecondsSinceEpoch}';
  }
}
