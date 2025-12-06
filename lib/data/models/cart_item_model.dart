import 'package:quickbite/data/models/menu_item_model.dart';
import 'package:quickbite/data/models/restaurant_model.dart';

class CartItem {
  final MenuItem menuItem;
  final Restaurant restaurant;
  int quantity;

  CartItem({
    required this.menuItem,
    required this.restaurant,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;
}
