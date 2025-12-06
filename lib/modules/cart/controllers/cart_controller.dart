import 'package:get/get.dart';
import 'package:quickbite/data/models/cart_item_model.dart';
import 'package:quickbite/data/models/menu_item_model.dart';
import 'package:quickbite/data/models/order_model.dart';
import 'package:quickbite/data/models/restaurant_model.dart';
import 'package:quickbite/data/repository/cart_repository.dart';
import 'package:quickbite/data/repository/order_repository.dart';
import 'package:quickbite/data/services/delivery_service.dart';

class CartController extends GetxController {
  final CartRepository _cartRepository = Get.find();
  final OrderRepository _orderRepository = Get.find();

  RxList<CartItem> cartItems = <CartItem>[].obs;
  RxString promoCode = ''.obs;
  RxDouble promoDiscount = 0.0.obs;
  RxBool isFirstOrder = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromCache();
    checkFirstOrder();
  }

  Future<void> loadCartFromCache() async {
    try {
      final cachedCart = await _cartRepository.loadCart();
      cartItems.assignAll(cachedCart);
    } catch (e) {
      print('Error loading cart from cache: $e');
    }
  }

  void checkFirstOrder() async {
    final hasOrders = _orderRepository.hasOrders();
    isFirstOrder.value = !hasOrders;
  }

  void addToCart(MenuItem menuItem, Restaurant restaurant) {
    final existingItemIndex = cartItems.indexWhere(
      (item) =>
          item.menuItem.id == menuItem.id &&
          item.restaurant.id == restaurant.id,
    );

    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity++;
    } else {
      cartItems.add(CartItem(menuItem: menuItem, restaurant: restaurant));
    }
    cartItems.refresh();
    saveCartToCache();
  }

  void removeFromCart(String menuItemId, String restaurantId) {
    cartItems.removeWhere(
      (item) =>
          item.menuItem.id == menuItemId && item.restaurant.id == restaurantId,
    );
    saveCartToCache();
  }

  void updateQuantity(String menuItemId, String restaurantId, int newQuantity) {
    final item = cartItems.firstWhereOrNull(
      (item) =>
          item.menuItem.id == menuItemId && item.restaurant.id == restaurantId,
    );

    if (item != null) {
      if (newQuantity > 0) {
        item.quantity = newQuantity;
      } else {
        removeFromCart(menuItemId, restaurantId);
      }
    }
    cartItems.refresh();
    saveCartToCache();
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

    // Local promo code validation
    const promoCodes = {
      'SAVE50': {'discount': 50, 'minOrder': 700},
      'FIRST100': {'discount': 100, 'minOrder': 0, 'firstOrderOnly': true},
    };

    if (promoCodes.containsKey(code.toUpperCase())) {
      final promo = promoCodes[code.toUpperCase()]!;

      // Check if promo is for first order only
      if (promo['firstOrderOnly'] == true && !isFirstOrder.value) {
        Get.snackbar('Error', 'This promo is for first orders only');
        return;
      }

      // Check minimum order amount
      final discount = promo['discount'];
      final minOrder = promo['minOrder'] ?? 0;

      // Validate numeric types
      if (discount is num && minOrder is num) {
        if (subtotal >= minOrder) {
          promoCode.value = code.toUpperCase();
          promoDiscount.value = discount.toDouble(); // Safe now
          Get.snackbar('Success', 'Promo code applied!');
        } else {
          Get.snackbar('Error', 'Minimum order amount not met');
        }
      } else {
        Get.snackbar('Error', 'Invalid promo code format');
      }
    }
  }

  Future<void> saveCartToCache() async {
    try {
      await _cartRepository.saveCart(cartItems);
    } catch (e) {
      print('Error saving cart to cache: $e');
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

      // Create order
      final orderId = _orderRepository.generateOrderId();
      final order = Order(
        id: orderId,
        items: List.from(cartItems),
        customerName: customerName,
        phoneNumber: phoneNumber,
        deliveryAddress: deliveryAddress,
        deliveryInstructions: deliveryInstructions,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: promoDiscount.value,
        totalAmount: grandTotal,
        orderDate: DateTime.now(),
        status: 'Confirmed',
        promoCode: promoCode.value.isNotEmpty ? promoCode.value : null,
      );

      // Save order
      await _orderRepository.saveOrder(order);

      // Clear cart
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
    saveCartToCache();
  }
}
