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

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'restaurant': restaurant.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      restaurant: Restaurant.fromJson(json['restaurant']),
      quantity: json['quantity'],
    );
  }
}
