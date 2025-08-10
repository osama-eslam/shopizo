import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  bool isFavorite = false;
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.reviews,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] ?? 0,
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      price: (json["price"] ?? 0).toDouble(),
      discountPercentage: (json["discountPercentage"] ?? 0).toDouble(),
      rating: (json["rating"] ?? 0).toDouble(),
      stock: json["stock"] ?? 0,
      brand: json["brand"] ?? '',
      category: json["category"] ?? '',
      thumbnail: json["thumbnail"] ?? '',
      images: json["images"] != null ? List<String>.from(json["images"]) : [],
      reviews:
          json["reviews"] != null
              ? List<Review>.from(
                json["reviews"].map((r) => Review.fromJson(r)),
              )
              : [],
    );
  }
}

class Review {
  final int rating;
  final String? comment;
  final String? date;
  final String? reviewerName;
  final String? reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json["rating"],
      comment: json["comment"],
      date: json["date"],
      reviewerName: json["reviewerName"],
      reviewerEmail: json["reviewerEmail"],
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final url = Uri.parse("https://dummyjson.com/products?limit=200");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List products = data["products"];
    return products.map<Product>((p) => Product.fromJson(p)).toList();
  } else {
    throw Exception("Internet error");
  }
}
