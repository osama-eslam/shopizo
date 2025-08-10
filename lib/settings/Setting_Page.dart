import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/ui/pages/orders/saved_products_page.dart';
import 'package:image_picker_demo/ui/pages/statistics/statistics_page.dart';
import 'package:image_picker_demo/ui/pages/card/cart_page.dart';
import 'package:image_picker_demo/ui/pages/favorite/favorite_page.dart';
import 'package:image_picker_demo/ui/pages/theme/theme_button.dart';
import 'package:image_picker_demo/ui/widgets/language_switcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget buildSettingCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings".tr),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            buildSettingCard(
              icon: Icons.brightness_6,
              title: "toggle_theme".tr,
              color: Colors.indigo,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(content: ThemeToggleButton()),
                );
              },
            ),
            buildSettingCard(
              icon: Icons.favorite,
              title: "favorites".tr,
              color: Colors.pink,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritePage()),
                );
              },
            ),
            buildSettingCard(
              icon: Icons.shopping_cart,
              title: "cart".tr,
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
            buildSettingCard(
              icon: Icons.language,
              title: "change_language".tr,
              color: Colors.amber,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(content: LanguageSwitcher()),
                );
              },
            ),
            buildSettingCard(
              icon: Icons.show_chart,
              title: "graph_product".tr,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatisticsPage()),
                );
              },
            ),
            buildSettingCard(
              icon: Icons.list_alt,
              title: "my_orders".tr,
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SavedProductsPage()),
                );
              },
            ),
            buildSettingCard(
              icon: Icons.help_outline,
              title: "terms_and_conditions".tr,
              color: Colors.orange,
              onTap: () {
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
      ),
    );
  }
}
