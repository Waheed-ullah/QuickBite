import 'package:get/get.dart';
import 'package:quickbite/data/models/order_model.dart';

class OrderController extends GetxController {
  final RxList<Order> _orders = <Order>[].obs;

  List<Order> get orders => _orders;

  Future<void> placeOrder(Order order) async {
    _orders.insert(0, order);

    await _saveOrdersToCache();
  }

  Future<void> _saveOrdersToCache() async {}

  Future<void> loadOrdersFromCache() async {}
}
