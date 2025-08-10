import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/ui/widgets/line_chart_widget.dart';
import 'package:image_picker_demo/ui/widgets/stat_card.dart';
import '../../../utils/data_generator.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late List<FlSpot> salesData;
  late AnimationController _controller;
  Animation<double>? _animation;

  double salesValue = 1.2;
  double customersValue = 0.85;
  double ordersValue = 0.42;

  @override
  void initState() {
    super.initState();
    salesData = generateRandomData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<FlSpot> _getAnimatedSpots() {
    if (_animation == null) return [];
    int totalPoints = salesData.length;
    double progress = totalPoints * _animation!.value;
    int fullPoints = progress.floor();
    double t = progress - fullPoints;
    List<FlSpot> spots = [];
    for (int i = 0; i < fullPoints; i++) {
      spots.add(salesData[i]);
    }
    if (fullPoints < totalPoints && fullPoints > 0) {
      final prev = salesData[fullPoints - 1];
      final next = salesData[fullPoints];
      double interpolatedY = prev.y + (next.y - prev.y) * t;
      double interpolatedX = prev.x + (next.x - prev.x) * t;
      spots.add(FlSpot(interpolatedX, interpolatedY));
    }
    return spots;
  }

  void _refreshData() {
    setState(() {
      salesData = generateRandomData();
      salesValue = double.parse(
        slightRandomChange(salesValue).toStringAsFixed(2),
      );
      customersValue = double.parse(
        slightRandomChange(customersValue).toStringAsFixed(2),
      );
      ordersValue = double.parse(
        slightRandomChange(ordersValue).toStringAsFixed(2),
      );
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundGradient = LinearGradient(
      colors:
          isDark
              ? [Colors.indigo.shade900, Colors.black]
              : [Colors.blue.shade300, Colors.white],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final cardColor =
        isDark ? theme.colorScheme.surface : Colors.white.withOpacity(0.9);

    return Scaffold(
      appBar: AppBar(
        title: Text("store_statistics".tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Center(
          child:
              _animation == null
                  ? const CircularProgressIndicator()
                  : AnimatedBuilder(
                    animation: _animation!,
                    builder: (context, child) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 80,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StatCard(
                                    title: "sales".tr,
                                    value: formatNumber(salesValue),
                                    color: const Color(0xFF4A90E2),
                                    icon: Icons.shopping_cart,
                                  ),
                                  StatCard(
                                    title: "customers".tr,
                                    value: formatNumber(customersValue),
                                    color: const Color(0xFF7ED321),
                                    icon: Icons.people,
                                  ),
                                  StatCard(
                                    title: "orders".tr,
                                    value: formatNumber(ordersValue),
                                    color: const Color(0xFFF5A623),
                                    icon: Icons.receipt_long,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: cardColor,
                                elevation: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: AspectRatio(
                                    aspectRatio: 1.7,
                                    child: LineChartWidget(
                                      spots: _getAnimatedSpots(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: _refreshData,
                                icon: const Icon(Icons.refresh),
                                label: Text("refresh_data".tr),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor:
                                      isDark
                                          ? Colors.tealAccent.shade400
                                          : Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
