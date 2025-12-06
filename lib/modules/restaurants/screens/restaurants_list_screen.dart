import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickbite/modules/restaurants/controllers/restaurant_controller.dart';
import 'package:quickbite/modules/restaurants/widgets/restaurant_card.dart';
import 'package:quickbite/common/widgets/loading_widget.dart';
import 'package:quickbite/common/widgets/error_widget.dart';

class RestaurantsListScreen extends StatelessWidget {
  const RestaurantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RestaurantController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickBite Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.toNamed('/cart');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.error.isNotEmpty) {
          return CustomErrorWidget(
            error: controller.error.value,
            onRetry: controller.loadRestaurants,
          );
        }

        if (controller.restaurants.isEmpty) {
          return const Center(child: Text('No restaurants available'));
        }

        return Column(
          children: [
            // Offline mode indicator
            if (controller.isOfflineMode.value)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wifi_off, size: 16),
                    SizedBox(width: 8),
                    Text('Offline Mode - Showing cached data'),
                  ],
                ),
              ),

            // Filter/Sort bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: 'rating',
                      items: const [
                        DropdownMenuItem(
                          value: 'rating',
                          child: Text('Sort by Rating'),
                        ),
                        DropdownMenuItem(
                          value: 'name',
                          child: Text('Sort by Name'),
                        ),
                      ],
                      onChanged: (value) {
                        // Implement sorting
                      },
                      decoration: InputDecoration(
                        hintText: 'Sort by',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Show filter dialog
                    },
                  ),
                ],
              ),
            ),

            // Restaurants list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = controller.restaurants[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Get.toNamed(
                        '/restaurant-detail',
                        arguments: restaurant.id,
                      );
                    },
                    onFavoriteToggle: () {
                      controller.toggleFavorite(restaurant.id);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
