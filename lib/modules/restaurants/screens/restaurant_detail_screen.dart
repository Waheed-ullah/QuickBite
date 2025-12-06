import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickbite/modules/restaurants/controllers/restaurant_controller.dart';
import 'package:quickbite/modules/cart/controllers/cart_controller.dart';
import 'package:quickbite/modules/restaurants/widgets/menu_item_card.dart';
import 'package:quickbite/res/app_colors.dart';

class RestaurantDetailScreen extends StatelessWidget {
  RestaurantDetailScreen({super.key});

  final RestaurantController restaurantController = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    final String restaurantId = Get.arguments;
    final restaurant = restaurantController.getRestaurantById(restaurantId);

    if (restaurant == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant Not Found'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(child: Text('Restaurant not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Favorite button - Now properly wrapped with Obx
          Obx(() {
            // Get fresh restaurant data to ensure reactive updates
            final updatedRestaurant = restaurantController.getRestaurantById(
              restaurantId,
            );
            final isFavorite = updatedRestaurant?.isFavorite ?? false;

            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                restaurantController.toggleFavorite(restaurant.id);
              },
            );
          }),
          // Cart button
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.toNamed('/cart');
                },
              ),
              // Cart item count badge
              Obx(() {
                final cartItemsCount = cartController.cartItems.length;
                if (cartItemsCount == 0) return const SizedBox();

                return Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartItemsCount.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Chip(
                      label: Text(restaurant.cuisine),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(restaurant.zone),
                      backgroundColor: AppColors.secondary.withOpacity(0.1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Delivery Zone: ${restaurant.zone}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Delivery Fee: ${_getDeliveryFeeText(restaurant.zone)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Menu section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Menu',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // Menu items list
          Expanded(
            child: restaurant.menu.isEmpty
                ? const Center(
                    child: Text(
                      'No menu items available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: restaurant.menu.length,
                    itemBuilder: (context, index) {
                      final menuItem = restaurant.menu[index];
                      return MenuItemCard(
                        menuItem: menuItem,
                        onAddToCart: () {
                          cartController.addToCart(menuItem, restaurant);
                          // Show success animation
                          Get.snackbar(
                            'Added to Cart',
                            '${menuItem.name} added to cart',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getDeliveryFeeText(String zone) {
    switch (zone) {
      case 'Urban':
        return '₹20';
      case 'Suburban':
        return '₹30';
      case 'Remote':
        return '₹50';
      default:
        return '₹30';
    }
  }
}
