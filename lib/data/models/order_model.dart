import 'package:quickbite/data/models/cart_item_model.dart';
import 'package:quickbite/data/models/menu_item_model.dart';
import 'package:quickbite/data/models/restaurant_model.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final String customerName;
  final String phoneNumber;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final String? promoCode;

  Order({
    required this.id,
    required this.items,
    required this.customerName,
    required this.phoneNumber,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalAmount,
    required this.orderDate,
    this.status = 'Pending',
    this.promoCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items
          .map(
            (item) => {
              'menuItem': {
                'id': item.menuItem.id,
                'name': item.menuItem.name,
                'price': item.menuItem.price,
              },
              'restaurant': {
                'id': item.restaurant.id,
                'name': item.restaurant.name,
                'zone': item.restaurant.zone,
              },
              'quantity': item.quantity,
            },
          )
          .toList(),
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'deliveryAddress': deliveryAddress,
      'deliveryInstructions': deliveryInstructions,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'promoCode': promoCode,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map(
            (item) => CartItem(
              menuItem: MenuItem(
                id: item['menuItem']['id'],
                name: item['menuItem']['name'],
                description: '',
                price: (item['menuItem']['price'] as num).toDouble(),
              ),
              restaurant: Restaurant(
                id: item['restaurant']['id'],
                name: item['restaurant']['name'],
                zone: item['restaurant']['zone'],
                rating: 0,
                cuisine: '',
                menu: [],
              ),
              quantity: item['quantity'],
            ),
          )
          .toList(),
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      deliveryAddress: json['deliveryAddress'],
      deliveryInstructions: json['deliveryInstructions'],
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
      promoCode: json['promoCode'],
    );
  }

  // Copy with method for immutability
  Order copyWith({
    String? id,
    List<CartItem>? items,
    String? customerName,
    String? phoneNumber,
    String? deliveryAddress,
    String? deliveryInstructions,
    double? subtotal,
    double? deliveryFee,
    double? discount,
    double? totalAmount,
    DateTime? orderDate,
    String? status,
    String? promoCode,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}
