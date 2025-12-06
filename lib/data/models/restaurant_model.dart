import 'package:quickbite/data/models/menu_item_model.dart';

class Restaurant {
  final String id;
  final String name;
  final String zone;
  final double rating;
  final String cuisine;
  final List<MenuItem> menu;
  bool isFavorite;

  Restaurant({
    required this.id,
    required this.name,
    required this.zone,
    required this.rating,
    required this.cuisine,
    required this.menu,
    this.isFavorite = false,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      zone: json['zone'],
      rating: (json['rating'] as num).toDouble(),
      cuisine: json['cuisine'],
      menu: (json['menu'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }
}
