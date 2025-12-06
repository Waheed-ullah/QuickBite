import 'package:hive/hive.dart';
import 'package:quickbite/data/models/menu_item_model.dart';

part 'restaurant_model.g.dart';

@HiveType(typeId: 0)
class Restaurant {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String zone;

  @HiveField(3)
  final double rating;

  @HiveField(4)
  final String cuisine;

  @HiveField(5)
  final List<MenuItem> menu;

  @HiveField(6)
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'zone': zone,
      'rating': rating,
      'cuisine': cuisine,
      'menu': menu.map((item) => item.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? zone,
    double? rating,
    String? cuisine,
    List<MenuItem>? menu,
    bool? isFavorite,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      zone: zone ?? this.zone,
      rating: rating ?? this.rating,
      cuisine: cuisine ?? this.cuisine,
      menu: menu ?? this.menu,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
