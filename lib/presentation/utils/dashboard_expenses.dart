import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DashboardExpenses extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final String currencySymbol;

  const DashboardExpenses({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          spacing: 6.w,
          children: [
            Icon(
              Icons.circle,
              color: Theme.of(context).primaryColor,
              size: 12.sp,
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor,
                  ),
                  text: "Total Income: ",
                  children: [
                    TextSpan(
                      text: CurrencyFormater.formatAmountWithSymbol(
                        context,
                        totalIncome,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  ]),
            ),
          ],
        ),
        Row(
          spacing: 6.w,
          children: [
            Icon(
              Icons.circle,
              color: expenseRedText,
              size: 12.sp,
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor,
                  ),
                  text: "Total Expense: ",
                  children: [
                    TextSpan(
                      text: CurrencyFormater.formatAmountWithSymbol(
                        context,
                        totalExpense,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  ]),
            ),
          ],
        ),
        SizedBox(
          height: 200.h,
          child: SfCircularChart(
            margin: EdgeInsets.zero,
            series: <CircularSeries>[
              DoughnutSeries<_SummaryData, String>(
                dataSource: [
                  _SummaryData('Total Expense', totalExpense, expenseRedText),
                  _SummaryData('Total Income', totalIncome,
                      Theme.of(context).primaryColor),
                ],
                pointColorMapper: (data, _) => data.color,
                xValueMapper: (data, _) => data.label,
                yValueMapper: (data, _) => data.value,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                ),
                legendIconType: LegendIconType.circle,
                cornerStyle: CornerStyle.bothCurve,
                radius: '100%',
                innerRadius: "80%",
              ),
            ],
            annotations: [
              CircularChartAnnotation(
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CurrencyFormater.formatAmount(
                            context,
                            totalIncome,
                            compact: true,
                          ),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          currencySymbol,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CurrencyFormater.formatAmount(
                            context,
                            totalExpense,
                            compact: true,
                          ),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: expenseRedText,
                          ),
                        ),
                        Text(
                          currencySymbol,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: expenseRedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Text(
          LocaleKeys.trendingByMonth.tr(args: [5.2.toString()]),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class _SummaryData {
  final String label;
  final double value;
  final Color color;
  _SummaryData(this.label, this.value, this.color);
}
