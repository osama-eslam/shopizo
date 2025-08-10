import 'package:flutter/material.dart';
import 'package:image_picker_demo/core/favorite_helper.dart';
import 'package:image_picker_demo/data/api/product_api.dart';
import 'package:image_picker_demo/ui/pages/shared/product_card.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryTitle;
  final List<String> subCategories;

  const CategoryProductsPage({
    super.key,
    required this.categoryTitle,
    required this.subCategories,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreProducts();
      }
    });
  }

  Future<void> _loadMoreProducts() async {
    _isLoading = true;
    setState(() {});

    try {
      final allProducts = await fetchProducts();
      final filtered =
          allProducts
              .where((p) => widget.subCategories.contains(p.category))
              .toList();

      final start = _currentPage * _itemsPerPage;
      final end = start + _itemsPerPage;

      if (start < filtered.length) {
        final newProducts = filtered.sublist(
          start,
          end > filtered.length ? filtered.length : end,
        );

        for (var p in newProducts) {
          p.isFavorite = await FavoriteHelper.isFavorite(p.id);
        }

        _products.addAll(newProducts);
        _currentPage++;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      print("$e");
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryTitle.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body:
          _products.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: _products.length + (_hasMore ? 1 : 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  if (index == _products.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final product = _products[index];

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
    );
  }
}
