class CartItem {
  final int id;
  final String title;
  final double price;
  final double rating;
  final String thumbnail;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'rating': rating,
    'thumbnail': thumbnail,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      price: (json['price']).toDouble(),
      rating: (json['rating']).toDouble(),
      thumbnail: json['thumbnail'],
      quantity: json['quantity'] ?? 1,
    );
  }
}
