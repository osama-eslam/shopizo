import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

final Random random = Random();

List<FlSpot> generateRandomData() {
  return List.generate(
    6,
    (index) => FlSpot(index.toDouble(), random.nextInt(10) + 1.0),
  );
}

double slightRandomChange(double base) {
  if (random.nextDouble() < 0.3) {
    return base;
  }
  final changePercent = (random.nextDouble() * 0.2) - 0.1;
  double newValue = base * (1 + changePercent);
  if (newValue < 0) newValue = 0;
  return newValue;
}

String formatNumber(double value) {
  if (value >= 1) {
    return "${value.toStringAsFixed(2)}M";
  } else {
    return "${(value * 1000).toStringAsFixed(0)}K";
  }
}
