import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DashboardPieData extends StatelessWidget {
  final List<PieCategoryData> pieData;
  const DashboardPieData({super.key, required this.pieData});

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('MMMM');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Parties",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        Text(
          LocaleKeys.fromDateToDate.tr(
            args: [
              format.format(DateTime.now()),
              format.format(
                DateTime.now().add(
                  const Duration(days: 30),
                ),
              ),
              DateTime.now().year.toString(),
            ],
          ),
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor,
          ),
        ),
        Center(
          child: SizedBox(
            height: 200.h,
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              series: <CircularSeries>[
                PieSeries<PieCategoryData, String>(
                  dataSource: pieData,
                  pointColorMapper: (PieCategoryData data, _) => data.color,
                  xValueMapper: (PieCategoryData data, _) => data.category,
                  yValueMapper: (PieCategoryData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    labelIntersectAction: LabelIntersectAction.shift,
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  legendIconType: LegendIconType.seriesType,
                ),
              ],
            ),
          ),
        ),
        Text(
          LocaleKeys.trendingByMonth.tr(
            args: [
              pieData
                  .fold<double>(0, (sum, item) => sum + item.value)
                  .toStringAsFixed(1)
            ],
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class PieCategoryData {
  final String category;
  final double value;
  final Color color;
  PieCategoryData(this.category, this.value, this.color);
}
