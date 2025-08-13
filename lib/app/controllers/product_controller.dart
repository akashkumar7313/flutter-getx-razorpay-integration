import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading(true);
    errorMessage('');
    final url = Uri.parse('https://dummyjson.com/products');

    try {
      final response = await http.get(url);
      print('DEBUG: Status Code = ${response.statusCode}');
      print(
        'DEBUG: Response Body = ${response.body.substring(0, 200)}...',
      ); // first 200 chars

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List productsJson = data['products'] ?? [];
        print('DEBUG: Parsed product count = ${productsJson.length}');

        var productResult = productsJson.map((json) {
          try {
            return Product.fromJson(json);
          } catch (e) {
            print('JSON Parse Error: $e\nJSON: $json');
            rethrow; // optional: stop further mapping
          }
        }).toList();

        products.assignAll(productResult);
      } else {
        errorMessage('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error: $e');
      print('EXCEPTION in fetchProducts: $e');
    } finally {
      isLoading(false);
    }
  }
}
