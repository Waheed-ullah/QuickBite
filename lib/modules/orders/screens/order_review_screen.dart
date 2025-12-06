import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickbite/modules/cart/controllers/cart_controller.dart';
import 'package:quickbite/modules/orders/controllers/order_controller.dart';
import 'package:quickbite/common/widgets/custom_button.dart';
import 'package:quickbite/res/app_colors.dart';

class OrderReviewScreen extends StatelessWidget {
  OrderReviewScreen({super.key});

  final CartController cartController = Get.find();
  final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> deliveryDetails = Get.arguments ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Order Review'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Order confirmed text
            const Center(
              child: Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Your order has been placed successfully',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 32),

            // Order details card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Delivery details
                    _buildDetailRow(
                      'Name',
                      deliveryDetails['name'] ?? 'Not provided',
                    ),
                    _buildDetailRow(
                      'Phone',
                      deliveryDetails['phone'] ?? 'Not provided',
                    ),
                    _buildDetailRow(
                      'Address',
                      deliveryDetails['address'] ?? 'Not provided',
                      isMultiLine: true,
                    ),
                    if (deliveryDetails['notes']?.isNotEmpty ?? false)
                      _buildDetailRow(
                        'Instructions',
                        deliveryDetails['notes'],
                        isMultiLine: true,
                      ),

                    const Divider(height: 32),

                    // Order summary
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Obx(() {
                      return Column(
                        children: [
                          _buildSummaryRow(
                            'Items',
                            '₹${cartController.subtotal.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'Delivery Fee',
                            '₹${cartController.deliveryFee.toStringAsFixed(2)}',
                          ),
                          if (cartController.promoDiscount.value > 0) ...[
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              'Promo Discount',
                              '-₹${cartController.promoDiscount.value.toStringAsFixed(2)}',
                              isDiscount: true,
                            ),
                          ],
                          const Divider(height: 16),
                          _buildSummaryRow(
                            'Total Amount',
                            '₹${cartController.grandTotal.toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Order items list
            Obx(() {
              return Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...cartController.cartItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.menuItem.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${item.restaurant.name} • Qty: ${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${(item.menuItem.price * item.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 32),

            // Estimated delivery time
            Card(
              color: AppColors.primaryLight,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Delivery Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '30-45 minutes',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Soon',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Track Order',
                    onPressed: () {
                      // In prototype, just show a message
                      Get.snackbar(
                        'Order Tracking',
                        'Order tracking would be implemented in production',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    backgroundColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Back to Home',
                    onPressed: () {
                      // Clear cart and go to restaurants list
                      cartController.clearCart();
                      Get.until((route) => route.isFirst);
                    },
                    outlined: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String? value, {
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'Not provided',
            style: TextStyle(fontSize: 16),
            maxLines: isMultiLine ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : null,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}
