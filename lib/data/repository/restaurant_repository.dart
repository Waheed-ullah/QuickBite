import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickbite/data/models/restaurant_model.dart';

class RestaurantRepository extends GetxService {
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/restaurants.json',
      );
      final jsonData = json.decode(jsonString);

      final restaurants = (jsonData['restaurants'] as List)
          .map((item) => Restaurant.fromJson(item))
          .toList();

      return restaurants;
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }
}
