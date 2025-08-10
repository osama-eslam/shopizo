import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/core/favorite_helper.dart';
import 'package:image_picker_demo/data/api/product_api.dart';
import 'package:image_picker_demo/ui/pages/shared/product_card.dart';

class BestRatedProductsSection extends StatefulWidget {
  const BestRatedProductsSection({super.key});

  @override
  State<BestRatedProductsSection> createState() =>
      _BestRatedProductsSectionState();
}

class _BestRatedProductsSectionState extends State<BestRatedProductsSection> {
  List<Product> _allSortedProducts = [];
  List<Product> _visibleProducts = [];
  bool _isLoading = true;
  final int _itemsPerPage = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await fetchProducts();
      products.sort((a, b) => b.rating.compareTo(a.rating));
      final visible = products.take(_itemsPerPage).toList();
      for (var product in visible) {
        product.isFavorite = await FavoriteHelper.isFavorite(product.id);
      }

      setState(() {
        _allSortedProducts = products;
        _visibleProducts = visible;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading products: $e");
      setState(() => _isLoading = false);
    }
  }

  void _loadMore() {
    final nextPage = _currentPage + 1;
    final nextItems =
        _allSortedProducts.take(nextPage * _itemsPerPage).toList();

    if (nextItems.length != _visibleProducts.length) {
      setState(() {
        _currentPage = nextPage;
        _visibleProducts = nextItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "top_rated_products".tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _visibleProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final product = _visibleProducts[index];

              return ProductCard(
                product: product,
                isAnimated: true,
                onFavoriteToggle: () async {
                  await FavoriteHelper.toggleFavorite(product);
                  setState(() {
                    product.isFavorite = !product.isFavorite;
                  });
                },
              );
            },
          ),
          if (_visibleProducts.length < _allSortedProducts.length)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: InkWell(
                onTap: _loadMore,
                child: Center(
                  child: Text(
                    "load_more".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
