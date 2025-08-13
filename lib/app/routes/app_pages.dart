import 'package:get/get.dart';
import '../views/home_page.dart';
import '../views/cart_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/cart', page: () => CartPage()),
    // Add more pages here as needed
  ];
}
