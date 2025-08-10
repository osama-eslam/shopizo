import 'package:flutter/material.dart';
import 'package:image_picker_demo/settings/Setting_Page.dart';
import 'package:image_picker_demo/ui/pages/card/cart_page.dart';
import 'package:image_picker_demo/ui/pages/favorite/favorite_page.dart';

import 'package:get/get.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isEndDrawer;

  const GradientAppBar({
    required this.title,
    required this.scaffoldKey,
    this.isEndDrawer = false,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading:
          isEndDrawer
              ? null
              : IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
      actions:
          isEndDrawer
              ? [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
                ),
              ]
              : null,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        title.tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}

Drawer buildCustomDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Text(
            'menu'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.pink),
          title: Text('favorites'.tr),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritePage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart, color: Colors.teal),
          title: Text('cart'.tr),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.settings, color: Colors.blueGrey),
          title: Text('Settings'.tr),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help_outline, color: Colors.orange),
          title: Text(
            "terms_and_conditions".tr,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),

          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: Text("terms_and_conditions".tr),
                    content: Text("terms_and_conditions_content".tr),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("close".tr),
                      ),
                    ],
                  ),
            );
          },
        ),
      ],
    ),
  );
}
