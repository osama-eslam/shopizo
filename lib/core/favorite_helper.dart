import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker_demo/data/api/product_api.dart';

class FavoriteHelper {
  static const _key = 'favorite_products';

  static Future<void> toggleFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favList = prefs.getStringList(_key) ?? [];

    final productJson = json.encode({
      "id": product.id,
      "title": product.title,
      "price": product.price,
      "rating": product.rating,
      "thumbnail": product.thumbnail,
    });

    final exists = favList.any((item) => json.decode(item)['id'] == product.id);

    if (exists) {
      favList.removeWhere((item) => json.decode(item)['id'] == product.id);
    } else {
      favList.add(productJson);
    }

    await prefs.setStringList(_key, favList);
  }

  static Future<List<Product>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favList = prefs.getStringList(_key) ?? [];

    return favList.map((item) {
      final data = json.decode(item);
      return Product(
        id: data['id'],
        title: data['title'],
        description: '',
        price: (data['price']).toDouble(),
        discountPercentage: 0,
        rating: (data['rating']).toDouble(),
        stock: 0,
        brand: '',
        category: '',
        thumbnail: data['thumbnail'],
        images: [],
        reviews: [],
      );
    }).toList();
  }

  static Future<bool> isFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favList = prefs.getStringList(_key) ?? [];

    return favList.any((item) => json.decode(item)['id'] == id);
  }
}
