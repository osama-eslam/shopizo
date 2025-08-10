import 'dart:convert';
import 'package:image_picker_demo/ui/pages/categories/category_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/product_api.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  Future<void> addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];

    List<CartItem> items =
        cartItems.map((item) => CartItem.fromJson(jsonDecode(item))).toList();

    final index = items.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      items[index].quantity += 1;
    } else {
      items.add(
        CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          rating: product.rating,
          thumbnail: product.thumbnail,
          quantity: 1,
        ),
      );
    }

    List<String> updated =
        items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, updated);
  }

  Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];
    return cartItems
        .map((item) => CartItem.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];
    List<CartItem> items =
        cartItems.map((item) => CartItem.fromJson(jsonDecode(item))).toList();

    items.removeWhere((item) => item.id == productId);

    List<String> updated =
        items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, updated);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}

class SharedPrefsHelper {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
