import 'package:flutter/material.dart';
import 'package:image_picker_demo/core/shared_prefs_helper.dart';
import 'package:image_picker_demo/ui/pages/card/cart_page.dart';

class CartIconWithBadge extends StatefulWidget {
  const CartIconWithBadge({super.key});

  @override
  State<CartIconWithBadge> createState() => _CartIconWithBadgeState();
}

class _CartIconWithBadgeState extends State<CartIconWithBadge> {
  int totalQuantity = 0;

  @override
  void initState() {
    super.initState();
    loadCartQuantity();
  }

  Future<void> loadCartQuantity() async {
    final items = await CartService().getCartItems();
    int quantity = items.fold(0, (sum, item) => sum + item.quantity);
    setState(() {
      totalQuantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );

            await loadCartQuantity();
          },
        ),
        if (totalQuantity > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
              child: Text(
                '$totalQuantity',
                style: TextStyle(
                  color: theme.colorScheme.onError,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
