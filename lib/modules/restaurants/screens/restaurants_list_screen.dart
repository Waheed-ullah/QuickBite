import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickbite/modules/restaurants/controllers/restaurant_controller.dart';
import 'package:quickbite/modules/restaurants/widgets/restaurant_card.dart';
import 'package:quickbite/common/widgets/loading_widget.dart';
import 'package:quickbite/common/widgets/error_widget.dart';

class RestaurantsListScreen extends StatefulWidget {
  const RestaurantsListScreen({super.key});

  @override
  State<RestaurantsListScreen> createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  final RestaurantController controller = Get.find();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    controller.setSearchQuery(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickBite Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search restaurants or cuisine...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          controller.setSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),

          // Filter Chips Row
          SizedBox(
            height: 50,
            child: Obx(() {
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  // Sort dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.sortBy.value,
                        items: const [
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text('Rating'),
                          ),
                          DropdownMenuItem(value: 'name', child: Text('Name')),
                          DropdownMenuItem(
                            value: 'deliveryFee',
                            child: Text('Delivery Fee'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.setSortBy(value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Favorites filter
                  FilterChip(
                    label: const Text('Favorites'),
                    selected: controller.showFavoritesOnly.value,
                    onSelected: (_) => controller.toggleFavoritesFilter(),
                    avatar: controller.showFavoritesOnly.value
                        ? const Icon(Icons.favorite, size: 16)
                        : const Icon(Icons.favorite_border, size: 16),
                  ),
                  const SizedBox(width: 8),

                  // Cuisine filters
                  ...controller.getAvailableCuisines().map((cuisine) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cuisine),
                        selected: controller.selectedCuisines.contains(cuisine),
                        onSelected: (_) =>
                            controller.toggleCuisineFilter(cuisine),
                      ),
                    );
                  }).toList(),

                  // Clear filters button
                  if (controller.selectedCuisines.isNotEmpty ||
                      controller.searchQuery.isNotEmpty ||
                      controller.showFavoritesOnly.value)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: const Text('Clear All'),
                        onPressed: controller.clearAllFilters,
                        backgroundColor: Colors.red.shade50,
                        labelStyle: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            }),
          ),

          // Restaurants List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.error.isNotEmpty) {
                return CustomErrorWidget(
                  error: controller.error.value,
                  onRetry: controller.loadRestaurants,
                );
              }

              if (controller.filteredRestaurants.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No restaurants found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'Try changing your filters',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.filteredRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = controller.filteredRestaurants[index];
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
              );
            }),
          ),
        ],
      ),
    );
  }
}
