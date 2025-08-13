import 'package:get/get.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  // Map<Product, Quantity>
  final RxMap<Product, int> _cartItems = <Product, int>{}.obs;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product]! < 5) {
        _cartItems[product] = _cartItems[product]! + 1;
      }
    } else {
      _cartItems[product] = 1;
    }
  }

  void removeFromCart(Product product) {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product]! > 1) {
        _cartItems[product] = _cartItems[product]! - 1;
      } else {
        _cartItems.remove(product);
      }
    }
  }

  // Renamed for clarity
  void removeFromCartCompletely(Product product) {
    _cartItems.remove(product);
  }

  void clearCart() {
    _cartItems.clear();
  }

  int getQuantity(Product product) {
    return _cartItems[product] ?? 0;
  }

  Map<Product, int> get cartItems => _cartItems;

  int get totalItems => _cartItems.values.fold(0, (sum, qty) => sum + qty);

  double get totalPrice => _cartItems.entries
      .map((entry) => entry.key.discountedPrice * entry.value)
      .fold(0.0, (sum, itemTotal) => sum + itemTotal);
}
