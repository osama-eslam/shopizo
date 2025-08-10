import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;

  const LineChartWidget({Key? key, required this.spots}) : super(key: key);

  List<String> getLastSixMonths() {
    DateTime now = DateTime.now();
    List<String> months = [];
    for (int i = 5; i >= 0; i--) {
      DateTime date = DateTime(now.year, now.month - i, 1);
      months.add(DateFormat('MMM').format(date));
    }
    return months;
  }

  @override
  Widget build(BuildContext context) {
    List<String> lastSixMonths = getLastSixMonths();

    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < lastSixMonths.length) {
                  return Text(
                    lastSixMonths[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 12,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
            ),
            barWidth: 5,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4A90E2).withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
