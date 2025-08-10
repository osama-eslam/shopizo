import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_demo/ui/pages/shared/category_list_widget.dart';

class ProductSlider extends StatelessWidget {
  const ProductSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 250,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
        items:
            imageUrls.map((url) {
              return Image.asset(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            }).toList(),
      ),
    );
  }
}
