import 'package:get/get.dart';
import 'package:quickbite/modules/cart/screens/cart_screen.dart';
import 'package:quickbite/modules/cart/screens/checkout_screen.dart';
import 'package:quickbite/modules/orders/screens/order_review_screen.dart';
import 'package:quickbite/modules/restaurants/screens/restaurants_list_screen.dart';
import 'package:quickbite/modules/restaurants/screens/restaurant_detail_screen.dart';

class AppRoutes {
  static const restaurants = '/';
  static const restaurantDetail = '/restaurant-detail';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderReview = '/order-review';

  static List<GetPage> pages = [
    GetPage(name: restaurants, page: () => const RestaurantsListScreen()),
    GetPage(name: restaurantDetail, page: () => RestaurantDetailScreen()),
    GetPage(name: cart, page: () => const CartScreen()),
    GetPage(name: checkout, page: () => CheckoutScreen()),
    GetPage(name: orderReview, page: () => OrderReviewScreen()),
  ];
}
