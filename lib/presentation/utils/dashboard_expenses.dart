import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/models/chart_data_model.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/providers/chart_data_provider.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DashboardExpenses extends StatefulWidget {
  const DashboardExpenses({super.key});

  @override
  State<DashboardExpenses> createState() => _DashboardExpensesState();
}

class _DashboardExpensesState extends State<DashboardExpenses> {
  DateFormat format = DateFormat('MMMM');
  final summaryData = StatisticsProvider().getSummaryData();

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
                        138000,
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
                        24478,
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
              DoughnutSeries<ChartData, String>(
                dataSource: summaryData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.property,
                yValueMapper: (ChartData data, _) => data.value,
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
                            138000,
                            compact: true,
                          ),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          context
                                  .watch<OnboardingCubit>()
                                  .state
                                  .currencySymbol ??
                              "XAF",
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
                            24478,
                            compact: true,
                          ),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: expenseRedText,
                          ),
                        ),
                        Text(
                          context
                                  .watch<OnboardingCubit>()
                                  .state
                                  .currencySymbol ??
                              "XAF",
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
