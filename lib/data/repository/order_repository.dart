import 'package:get/get.dart';
import 'package:quickbite/data/models/order_model.dart';
import 'package:quickbite/data/repository/local_storage.dart';

class OrderRepository extends GetxService {
  final LocalStorage _localStorage = Get.find();
  final String _ordersKey = 'orders_data';

  Future<void> saveOrder(Order order) async {
    try {
      final orders = await getOrders();
      orders.insert(0, order);

      final ordersJson = orders.map((order) => order.toJson()).toList();
      await _localStorage.cacheOrders(ordersJson);

      // Also save as individual order for easy retrieval
      await _saveIndividualOrder(order);
    } catch (e) {
      throw Exception('Failed to save order: $e');
    }
  }

  Future<void> _saveIndividualOrder(Order order) async {
    await _localStorage.saveUserPreference('order_${order.id}', order.toJson());
  }

  Future<List<Order>> getOrders() async {
    try {
      final ordersData = _localStorage.getCachedOrders();
      if (ordersData == null) return [];

      return ordersData.map((data) => Order.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final orderData = _localStorage.getUserPreference('order_$orderId');
      if (orderData == null) return null;

      return Order.fromJson(orderData);
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final orders = await getOrders();
      final orderIndex = orders.indexWhere((order) => order.id == orderId);

      if (orderIndex != -1) {
        orders[orderIndex] = orders[orderIndex].copyWith(status: status);

        final ordersJson = orders.map((order) => order.toJson()).toList();
        await _localStorage.cacheOrders(ordersJson);

        // Update individual order
        final updatedOrder = orders[orderIndex];
        await _saveIndividualOrder(updatedOrder);
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> clearOrders() async {
    await _localStorage.clearCache(_ordersKey);
  }

  bool hasOrders() {
    return _localStorage.hasOrdersCache();
  }

  DateTime? getLastOrderDate() {
    return _localStorage.getOrdersCacheTime();
  }

  // For demo purposes - generate a unique order ID
  String generateOrderId() {
    final now = DateTime.now();
    return 'ORD${now.millisecondsSinceEpoch}';
  }
}
