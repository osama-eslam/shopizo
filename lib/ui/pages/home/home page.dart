import 'package:flutter/material.dart';
import 'package:image_picker_demo/ui/widgets/app_bar.dart';
import 'package:image_picker_demo/ui/pages/product/best_rated_products.dart';
import 'package:image_picker_demo/ui/widgets/icon_widget.dart';
import 'package:image_picker_demo/ui/pages/shared/product_slider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GradientAppBar(
        title: 'Shopizo',
        scaffoldKey: _scaffoldKey,
        isEndDrawer: true,
      ),
      endDrawer: buildCustomDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: ProductSlider(),
            ),
            const SizedBox(height: 30),
            CategoryCircles(),
            const SizedBox(height: 30),
            BestRatedProductsSection(),
          ],
        ),
      ),
    );
  }
}
