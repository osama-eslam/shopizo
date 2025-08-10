import 'package:flutter/material.dart';
import 'package:image_picker_demo/core/shared_prefs_helper.dart';
import 'package:image_picker_demo/ui/pages/orders/order_confirmation_page.dart';
import 'package:image_picker_demo/ui/pages/categories/category_card.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final service = CartService();
    final items = await service.getCartItems();
    setState(() => cartItems = items);
  }

  Future<void> _confirmClearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("confirm".tr),
            content: Text("clear_cart_confirm".tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("close".tr),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("yes_clear".tr),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await CartService().clearCart();
      setState(() => cartItems = []);
    }
  }

  Future<void> _confirmRemoveItem(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("remove_item".tr),
            content: Text("remove_confirm".tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("close".tr),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("remove".tr),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await CartService().removeFromCart(id);
      loadCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text("my_cart".tr),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _confirmClearCart,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child:
                  cartItems.isEmpty
                      ? Center(
                        child: Text(
                          "cart_empty".tr,
                          style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: 18,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.thumbnail,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                item.title,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${'rating'.tr}: ${item.rating}"),
                                    Text("${'price'.tr}: \$${item.price}"),
                                    Text("${'quantity'.tr}: ${item.quantity}"),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: theme.colorScheme.error,
                                ),
                                onPressed: () => _confirmRemoveItem(item.id),
                              ),
                            ),
                          );
                        },
                      ),
            ),
            if (cartItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => OrderConfirmationPage(cartItems: cartItems),
                      ),
                    );
                  },
                  child: Text("proceed_checkout".tr),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
