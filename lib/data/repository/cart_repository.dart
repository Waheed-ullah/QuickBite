import 'package:get/get.dart';
import 'package:quickbite/data/models/cart_item_model.dart';
import 'package:quickbite/data/models/menu_item_model.dart';
import 'package:quickbite/data/models/restaurant_model.dart';
import 'package:quickbite/data/repository/local_storage.dart';

class CartRepository extends GetxService {
  final LocalStorage _localStorage = Get.find();

  Future<void> saveCart(List<CartItem> cartItems) async {
    final cartData = cartItems
        .map(
          (item) => {
            'menuItem': {
              'id': item.menuItem.id,
              'name': item.menuItem.name,
              'description': item.menuItem.description,
              'price': item.menuItem.price,
            },
            'restaurant': {
              'id': item.restaurant.id,
              'name': item.restaurant.name,
              'zone': item.restaurant.zone,
              'rating': item.restaurant.rating,
              'cuisine': item.restaurant.cuisine,
            },
            'quantity': item.quantity,
          },
        )
        .toList();

    await _localStorage.cacheCart(cartData);
  }

  Future<List<CartItem>> loadCart() async {
    final cartData = _localStorage.getCachedCart();
    if (cartData == null) return [];

    return cartItemsFromJson(cartData);
  }

  List<CartItem> cartItemsFromJson(List<dynamic> json) {
    return json.map((item) {
      final menuItemData = item['menuItem'];
      final restaurantData = item['restaurant'];

      return CartItem(
        menuItem: MenuItem(
          id: menuItemData['id'],
          name: menuItemData['name'],
          description: menuItemData['description'],
          price: (menuItemData['price'] as num).toDouble(),
        ),
        restaurant: Restaurant(
          id: restaurantData['id'],
          name: restaurantData['name'],
          zone: restaurantData['zone'],
          rating: (restaurantData['rating'] as num).toDouble(),
          cuisine: restaurantData['cuisine'],
          menu: [],
        ),
        quantity: item['quantity'],
      );
    }).toList();
  }

  Future<void> clearCart() async {
    await _localStorage.cacheCart([]);
  }
}
