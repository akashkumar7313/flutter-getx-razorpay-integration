import 'package:flutter/material.dart';
import 'package:flutter_getx/app/services/payment_service.dart';
import 'package:flutter_getx/app/views/payment_success_page.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 168, 162, 162),
                Color.fromARGB(255, 229, 142, 142),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Your Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        final cartEntries = cartController.cartItems.entries.toList();

        if (cartEntries.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: cartEntries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final product = cartEntries[index].key;
            final quantity = cartEntries[index].value;
            final discountedPrice = product.discountedPrice;
            final hasDiscount =
                product.discountPercentage != null &&
                product.discountPercentage! > 0;
            final totalPrice = discountedPrice * quantity;

            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Product Image small square
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Title
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          // Price and total price
                          hasDiscount
                              ? Row(
                                  children: [
                                    Text(
                                      '₹${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '₹${discountedPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '₹${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                          const SizedBox(height: 4),

                          Text(
                            'Total: ₹${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quantity Controls
                    product.isAvailable
                        ? Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (quantity > 1) {
                                    cartController.removeFromCart(product);
                                  } else {
                                    // Remove item if quantity is 1 and user taps minus
                                    cartController.removeFromCartCompletely(
                                      product,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                                color: quantity > 1 ? Colors.red : Colors.red,
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                onPressed: quantity < 5
                                    ? () {
                                        cartController.addToCart(product);
                                      }
                                    : null,
                                icon: const Icon(Icons.add_circle_outline),
                                color: quantity < 5
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ],
                          )
                        : const Text(
                            'Out of Stock',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        final totalAmount = cartController.totalPrice;
        if (totalAmount == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total: ₹${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (cartController.totalPrice == 0) return;

                  final paymentService = PaymentService();

                  paymentService.initRazorpay(
                    context: context,
                    amount: cartController.totalPrice,
                    onSuccess: () {
                      cartController.clearCart();
                      Get.snackbar(
                        'Order',
                        'Payment successful and order placed!',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green.shade100,
                        colorText: Colors.green.shade900,
                      );
                      Get.to(PaymentSuccessPage());
                    },
                    onFailure: () {
                      Get.snackbar(
                        'Order',
                        'Payment failed or cancelled.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red.shade100,
                        colorText: Colors.red.shade900,
                      );
                    },
                    userPhone: '9999999999', // 🔹 Dummy for test
                    userEmail: 'test@example.com', // 🔹 Dummy for test
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
