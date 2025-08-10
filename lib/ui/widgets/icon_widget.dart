import 'package:flutter/material.dart';
import 'package:image_picker_demo/data/models/categories.dart';
import 'package:image_picker_demo/ui/pages/categories/category_products_page.dart';
import 'package:get/get.dart';

class Category {
  final String nameKey;
  final String image;
  final String mainCategoryKey;
  final VoidCallback? onTap;

  Category({
    required this.nameKey,
    required this.image,
    required this.mainCategoryKey,
    this.onTap,
  });
}

class CategoryCircles extends StatelessWidget {
  final List<Category> categories = [
    Category(
      nameKey: 'category_accessories',
      image: 'assets/image/accessories.png',
      mainCategoryKey: 'Accessories',
    ),
    Category(
      nameKey: 'category_clothing',
      image: 'assets/image/clothing.png',
      mainCategoryKey: 'Clothing',
    ),
    Category(
      nameKey: 'category_electronics',
      image: 'assets/image/electronic.png',
      mainCategoryKey: 'Electronics',
    ),
    Category(
      nameKey: 'category_food_groceries',
      image: 'assets/image/foodstuffs.png',
      mainCategoryKey: 'Food & Groceries',
    ),
    Category(
      nameKey: 'category_personal_care',
      image: 'assets/image/personal_care.png',
      mainCategoryKey: 'Personal Care',
    ),
    Category(
      nameKey: 'category_footwear',
      image: 'assets/image/shoes.png',
      mainCategoryKey: 'Footwear',
    ),
    Category(
      nameKey: 'category_home_essentials',
      image: 'assets/image/home.png',
      mainCategoryKey: 'Home',
    ),
    Category(
      nameKey: 'category_transport',
      image: 'assets/image/transportation.png',
      mainCategoryKey: 'Transport',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              final key = category.mainCategoryKey;
              final subCats = mainCategories[key] ?? [];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CategoryProductsPage(
                        categoryTitle: category.nameKey.tr,
                        subCategories: subCats,
                      ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipOval(
                        child: Image.asset(
                          category.image,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.error,
                                color: theme.colorScheme.error,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 70,
                    child: Text(
                      category.nameKey.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color:
                            theme.textTheme.bodySmall?.color ??
                            theme.colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
