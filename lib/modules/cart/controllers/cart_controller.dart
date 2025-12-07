import 'package:get/get.dart';
import 'package:quickbite/data/models/cart_item_model.dart';
import 'package:quickbite/data/models/menu_item_model.dart';
import 'package:quickbite/data/models/restaurant_model.dart';
import 'package:quickbite/data/repository/local_storage.dart';
import 'package:quickbite/data/services/delivery_service.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  RxString promoCode = ''.obs;
  RxDouble promoDiscount = 0.0.obs;
  RxBool isFirstOrder = true.obs;
  late LocalStorage _localStorage;

  @override
  void onInit() {
    super.onInit();
    _localStorage = Get.find<LocalStorage>();
    loadCartFromStorage();
    checkFirstOrder();
  }

  void checkFirstOrder() {
    try {
      final orders = _localStorage.getOrders();
      isFirstOrder.value = orders.isEmpty;
    } catch (e) {
      print('Error checking first order: $e');
      isFirstOrder.value = true;
    }
  }

  Future<void> loadCartFromStorage() async {
    try {
      final cartData = _localStorage.getCartItems();
      final items = cartData.map((data) => _cartItemFromMap(data)).toList();
      cartItems.assignAll(items);
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  CartItem _cartItemFromMap(Map<String, dynamic> data) {
    return CartItem(
      menuItem: MenuItem.fromJson(data['menuItem']),
      restaurant: Restaurant.fromJson(data['restaurant']),
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> _cartItemToMap(CartItem item) {
    return {
      'menuItem': item.menuItem.toJson(),
      'restaurant': item.restaurant.toJson(),
      'quantity': item.quantity,
      'restaurantId': item.restaurant.id,
      'menuItemId': item.menuItem.id,
    };
  }

  void addToCart(MenuItem menuItem, Restaurant restaurant) {
    final existingIndex = cartItems.indexWhere(
      (item) =>
          item.menuItem.id == menuItem.id &&
          item.restaurant.id == restaurant.id,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity++;
      cartItems.refresh();

      _localStorage.updateCartQuantity(
        restaurant.id,
        menuItem.id,
        cartItems[existingIndex].quantity,
      );
    } else {
      final newItem = CartItem(
        menuItem: menuItem,
        restaurant: restaurant,
        quantity: 1,
      );
      cartItems.add(newItem);

      _localStorage.saveCartItem(_cartItemToMap(newItem));
    }

    Get.snackbar(
      'Added to Cart',
      '${menuItem.name} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void removeFromCart(String menuItemId, String restaurantId) {
    cartItems.removeWhere(
      (item) =>
          item.menuItem.id == menuItemId && item.restaurant.id == restaurantId,
    );
    _localStorage.removeCartItem(restaurantId, menuItemId);
  }

  void updateQuantity(String menuItemId, String restaurantId, int newQuantity) {
    final item = cartItems.firstWhereOrNull(
      (item) =>
          item.menuItem.id == menuItemId && item.restaurant.id == restaurantId,
    );

    if (item != null) {
      if (newQuantity > 0) {
        item.quantity = newQuantity;
        cartItems.refresh();

        _localStorage.updateCartQuantity(restaurantId, menuItemId, newQuantity);
      } else {
        removeFromCart(menuItemId, restaurantId);
      }
    }
  }

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    if (cartItems.isEmpty) return 0;
    final zones = cartItems.map((item) => item.restaurant.zone).toSet();
    return DeliveryService.calculateDeliveryFee(zones.toList());
  }

  double get grandTotal {
    return (subtotal + deliveryFee) - promoDiscount.value;
  }

  void applyPromoCode(String code) {
    if (code.isEmpty) {
      promoCode.value = '';
      promoDiscount.value = 0.0;
      Get.snackbar('Info', 'Promo code cleared');
      return;
    }

    const promoCodes = {
      'SAVE50': {'discount': 50, 'minOrder': 700, 'firstOrderOnly': false},
      'FIRST100': {'discount': 100, 'minOrder': 0, 'firstOrderOnly': true},
    };

    if (promoCodes.containsKey(code.toUpperCase())) {
      final promo = promoCodes[code.toUpperCase()]!;

      if (promo['firstOrderOnly'] == true && !isFirstOrder.value) {
        Get.snackbar('Error', 'This promo is for first orders only');
        return;
      }

      final discount = promo['discount'];
      final minOrder = promo['minOrder'] ?? 0;

      if (discount is num && minOrder is num) {
        if (subtotal >= minOrder) {
          promoCode.value = code.toUpperCase();
          promoDiscount.value = discount.toDouble();
          Get.snackbar('Success', 'Promo code applied!');
        } else {
          Get.snackbar('Error', 'Minimum order amount not met');
        }
      } else {
        Get.snackbar('Error', 'Invalid promo code format');
      }
    }
  }

  Future<void> saveCartToStorage() async {
    try {
      final cartData = cartItems.map(_cartItemToMap).toList();
      await _localStorage.cacheCart(cartData);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  Future<String> placeOrder({
    required String customerName,
    required String phoneNumber,
    required String deliveryAddress,
    String? deliveryInstructions,
  }) async {
    try {
      if (cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }

      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
      final order = {
        'id': orderId,
        'customerName': customerName,
        'phoneNumber': phoneNumber,
        'deliveryAddress': deliveryAddress,
        'deliveryInstructions': deliveryInstructions,
        'items': cartItems.map((item) => _cartItemToMap(item)).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'discount': promoDiscount.value,
        'totalAmount': grandTotal,
        'orderDate': DateTime.now().toIso8601String(),
        'status': 'Confirmed',
        'promoCode': promoCode.value.isNotEmpty ? promoCode.value : null,
      };

      final existingOrders = _localStorage.getCachedOrders();
      final updatedOrders = List<Map<String, dynamic>>.from(existingOrders)
        ..insert(0, order);

      await _localStorage.cacheOrders(updatedOrders);

      clearCart();

      return orderId;
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  void clearCart() {
    cartItems.clear();
    promoCode.value = '';
    promoDiscount.value = 0.0;
    _localStorage.clearCart();
  }
}
