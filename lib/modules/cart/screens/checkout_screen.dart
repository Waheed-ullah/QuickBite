import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickbite/modules/cart/controllers/cart_controller.dart';
import 'package:quickbite/common/widgets/custom_button.dart';
import 'package:quickbite/common/widgets/custom_textfield.dart';
import 'package:quickbite/res/app_colors.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final CartController cartController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery details section
            const Text(
              'Delivery Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: nameController,
              label: 'Full Name',
              hintText: 'Enter your name',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: phoneController,
              label: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Please enter a valid 10-digit number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: addressController,
              label: 'Delivery Address',
              hintText: 'Enter your delivery address',
              prefixIcon: Icons.location_on,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your delivery address';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: notesController,
              label: 'Delivery Instructions (Optional)',
              hintText: 'e.g., Call before delivery, Leave at door',
              prefixIcon: Icons.note,
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Order summary
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Obx(() {
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Items Total',
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
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'Total Amount',
                        '₹${cartController.grandTotal.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Payment method (simplified for prototype)
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.money, color: Colors.green),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Cash on Delivery',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Radio<bool>(
                      value: true,
                      groupValue: true,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Place order button
            CustomButton(
              text: 'Place Order',
              onPressed: () {
                if (_validateForm()) {
                  // Navigate to order review screen
                  Get.toNamed(
                    '/order-review',
                    arguments: {
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'notes': notesController.text,
                    },
                  );
                }
              },
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
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

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return false;
    }
    if (addressController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your delivery address');
      return false;
    }
    return true;
  }
}
