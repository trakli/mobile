import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/core/extensions/date_extension.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DashboardPieData extends StatelessWidget {
  final List<PieCategoryData> pieData;
  final DateTime? startDate;
  final DateTime? endDate;

  const DashboardPieData({
    super.key,
    required this.pieData,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('MMMM');
    DateFormat formatWithYear = DateFormat('MMMM yyyy');

    // Check if the date range is within the current month
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0);

    final isCurrentMonth = startDate != null &&
        endDate != null &&
        startDate!.isSameMonthAndYear(currentMonthStart) &&
        endDate!.isSameMonthAndYear(currentMonthEnd);

    String fromDateText;
    String toDateText;

    if (isCurrentMonth) {
      fromDateText = LocaleKeys.thisMonth.tr();
      toDateText = '';
    } else {
      fromDateText = formatWithYear.format(startDate ?? DateTime.now());
      toDateText = format
          .format(endDate ?? DateTime.now().add(const Duration(days: 30)));
    }

    // Check if there's data to show
    final hasData = pieData.isNotEmpty && pieData.any((data) => data.value > 0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          LocaleKeys.parties.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        Text(
          isCurrentMonth
              ? LocaleKeys.thisMonth.tr()
              : LocaleKeys.fromDateToDate.tr(
                  args: [
                    fromDateText,
                    toDateText,
                    (endDate ?? DateTime.now()).year.toString(),
                  ],
                ),
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor,
          ),
        ),
        if (!hasData)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 32.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    LocaleKeys.noTransactionData.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    LocaleKeys.addTransactionsToSeeChart.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
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
