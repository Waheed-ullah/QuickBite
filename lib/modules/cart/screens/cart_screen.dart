import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickbite/modules/cart/controllers/cart_controller.dart';
import 'package:quickbite/modules/cart/widgets/cart_item_widget.dart';
import 'package:quickbite/common/widgets/custom_button.dart';
import 'package:quickbite/res/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add some delicious items from restaurants',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: 'Browse Restaurants',
                    onPressed: () {
                      Get.until((route) => route.isFirst);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = controller.cartItems[index];
                  return CartItemWidget(
                    cartItem: cartItem,
                    onIncrease: () {
                      controller.updateQuantity(
                        cartItem.menuItem.id,
                        cartItem.restaurant.id,
                        cartItem.quantity + 1,
                      );
                    },
                    onDecrease: () {
                      controller.updateQuantity(
                        cartItem.menuItem.id,
                        cartItem.restaurant.id,
                        cartItem.quantity - 1,
                      );
                    },
                    onRemove: () {
                      controller.removeFromCart(
                        cartItem.menuItem.id,
                        cartItem.restaurant.id,
                      );
                    },
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                            text: controller.promoCode.value,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter promo code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (code) {
                            if (code.isNotEmpty) {
                              controller.applyPromoCode(code);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final controller = Get.find<CartController>();
                          final promoCode = controller.promoCode.value;
                          if (promoCode.isNotEmpty) {
                            controller.applyPromoCode(promoCode);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildPriceRow('Subtotal', controller.subtotal),
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Delivery Fee',
                    controller.deliveryFee,
                    description: _getDeliveryDescription(controller),
                  ),

                  if (controller.promoDiscount.value > 0)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildPriceRow(
                          'Promo Discount',
                          -controller.promoDiscount.value,
                          isDiscount: true,
                        ),
                      ],
                    ),

                  const Divider(height: 24),
                  _buildPriceRow(
                    'Grand Total',
                    controller.grandTotal,
                    isTotal: true,
                  ),
                  const SizedBox(height: 16),

                  CustomButton(
                    text: 'Proceed to Checkout',
                    onPressed: () {
                      Get.toNamed('/checkout');
                    },
                    backgroundColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    String? description,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isDiscount ? Colors.green : null,
              ),
            ),
            if (description != null)
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : null,
          ),
        ),
      ],
    );
  }

  String _getDeliveryDescription(CartController controller) {
    if (controller.cartItems.isEmpty) return '';

    final zones = controller.cartItems
        .map((item) => item.restaurant.zone)
        .toSet()
        .join(', ');

    return 'Based on zones: $zones';
  }
}
