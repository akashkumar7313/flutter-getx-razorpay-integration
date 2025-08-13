import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';

class ProductList extends StatelessWidget {
  final ProductController productController = ProductController();
  final CartController cartController;

  ProductList({Key? key, required this.cartController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = productController.products;

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) =>
          ProductCard(product: products[index], cartController: cartController),
    );
  }
}
