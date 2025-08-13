import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final CartController cartController;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartController,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int get quantity =>
      widget.cartController.getQuantity(widget.product); // centralized qty

  void _increment() {
    if (!widget.product.isAvailable || quantity >= 5) return;
    widget.cartController.addToCart(widget.product);
    setState(() {});
  }

  void _decrement() {
    if (quantity > 0) {
      widget.cartController.removeFromCart(widget.product);
      setState(() {});
    }
  }

  Widget buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final discountedPrice = p.discountedPrice;
    final hasDiscount =
        p.discountPercentage != null && p.discountPercentage! > 0;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                p.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Product Details + Quantity selector
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        'Brand: ${p.brand}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(p.category),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      buildRatingStars(p.rating),
                      const SizedBox(width: 6),
                      Text(
                        '(${p.ratingCount})',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    p.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          hasDiscount
                              ? Row(
                                  children: [
                                    Text(
                                      '₹${p.price.toStringAsFixed(2)}',
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '₹${p.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          if (hasDiscount)
                            Text(
                              '${p.discountPercentage!.toStringAsFixed(0)}% OFF',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 14,
                                color: p.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                p.isAvailable
                                    ? 'In Stock (${p.stock})'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  color: p.isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Quantity Controls or Add Button
                      p.isAvailable
                          ? Column(
                              children: [
                                quantity == 0
                                    ? ElevatedButton.icon(
                                        onPressed: _increment,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Add'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          IconButton(
                                            onPressed: _decrement,
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                            color: Colors.red,
                                          ),
                                          Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: quantity < 5
                                                ? _increment
                                                : null,
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                            ),
                                            color: quantity < 5
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ],
                                      ),

                                // Go to Cart shortcut
                              ],
                            )
                          : const Text(
                              "Out of Stock",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
