import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/core/favorite_helper.dart';
import 'package:image_picker_demo/data/api/product_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker_demo/ui/pages/product/product_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Product> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await FavoriteHelper.getFavorites();
    setState(() {
      _favorites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text("favorite_products".tr)),
      body:
          _favorites.isEmpty
              ? Center(
                child: Text(
                  "no_favorites".tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  itemCount: _favorites.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final product = _favorites[index];
                    return _buildFavoriteCard(product);
                  },
                ),
              ),
    );
  }

  Widget _buildFavoriteCard(Product product) {
    final cardColor = Theme.of(context).cardColor;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                placeholder:
                    (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${product.price}",
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        await FavoriteHelper.toggleFavorite(product);
                        _loadFavorites();
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
