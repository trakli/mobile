import 'dart:ui';

import 'package:trakli/models/chart_data_model.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/graph_widget.dart';
import 'dart:math' as math;

class StatisticsProvider {
  List<ChartStatistics> getChartData() {
    return [
      ChartStatistics("10", 100, 500),
      ChartStatistics("11", 440, 228),
      ChartStatistics("12", 300, 50),
      ChartStatistics("13", 550, 30),
      ChartStatistics("14", 350, 350),
    ];
  }

  List<ChartData> getSummaryData() {
    return [
      ChartData(
        'Total Expense',
        24478,
        expenseRedText,
      ),
      ChartData(
        'Total Income',
        138000,
        const Color(0xFF047844),
      ),
    ];
  }

  List<ChartData> getPieData = [
    ChartData(
      'Food',
      30,
      Color.fromARGB(
        255,
        math.Random().nextInt(256),
        math.Random().nextInt(256),
        math.Random().nextInt(256),
      ),
    ),
    ChartData(
      'Education',
      20,
      Color.fromARGB(
        255,
        math.Random().nextInt(256),
        math.Random().nextInt(256),
        math.Random().nextInt(256),
      ),
    ),
    ChartData(
      'Clothes',
      20,
      Color.fromARGB(
        255,
        math.Random().nextInt(256),
        math.Random().nextInt(256),
        math.Random().nextInt(256),
      ),
    ),
    ChartData(
      'Rents',
      10,
      Color.fromARGB(
        255,
        math.Random().nextInt(256),
        math.Random().nextInt(256),
        math.Random().nextInt(256),
      ),
    ),
    ChartData(
      'Girls',
      10,
      Color.fromARGB(
        255,
        math.Random().nextInt(256),
        math.Random().nextInt(256),
        math.Random().nextInt(256),
      ),
    ),
    ChartData(
      'Other',
      15,
      Color.fromARGB(
        255,
        math.Random().nextInt(256),
        math.Random().nextInt(256),
        math.Random().nextInt(256),
      ),
    ),
  ];

  List<Color> pieDataColors = [
    const Color.fromARGB(255, 244, 67, 54), // Red
    const Color.fromARGB(255, 33, 150, 243), // Blue
    const Color.fromARGB(255, 76, 175, 80), // Green
    const Color.fromARGB(255, 255, 235, 59), // Yellow
    const Color.fromARGB(255, 156, 39, 176), // Purple
    const Color.fromARGB(255, 255, 152, 0), // Orange
    const Color.fromARGB(255, 0, 188, 212), // Cyan
    const Color.fromARGB(255, 121, 85, 72), // Brown
    const Color.fromARGB(255, 205, 220, 57), // Lime
    const Color.fromARGB(255, 63, 81, 181), // Indigo
    const Color.fromARGB(255, 233, 30, 99), // Pink
    const Color.fromARGB(255, 0, 150, 136), // Teal
    const Color.fromARGB(255, 139, 195, 74), // Light Green
    const Color.fromARGB(255, 255, 87, 34), // Deep Orange
    const Color.fromARGB(255, 103, 58, 183), // Deep Purple
    const Color.fromARGB(255, 255, 193, 7), // Amber
    const Color.fromARGB(255, 96, 125, 139), // Blue Grey
    const Color.fromARGB(255, 0, 255, 255), // Aqua
    const Color.fromARGB(255, 255, 0, 255), // Magenta
    const Color.fromARGB(255, 0, 255, 0), // Bright Green
  ];
}
