class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double? discountPercentage;
  final String imageUrl;
  final String category;
  final double rating;
  final int ratingCount;
  final int stock;
  final String brand;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPercentage,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.ratingCount,
    required this.stock,
    required this.brand,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      imageUrl:
          json['thumbnail'] ??
          (json['images'] != null && json['images'].isNotEmpty
              ? json['images'][0]
              : ''),
      category: json['category'] ?? 'Unknown',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? 'No Brand',
    );
  }

  bool get isAvailable => stock > 0;

  double get discountedPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }
}
