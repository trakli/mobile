import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.transactionHistory.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          InkWell(
            onTap: () {
              AppNavigator.push(context, const AddTransactionScreen());
            },
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: const Color(0xFFEBEDEC),
              ),
              padding: EdgeInsets.all(8.r),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 24.r,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(appPrimaryColor),
              ),
            );
          }

          final transactions = state.transactions;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Column(
              children: [
                SizedBox(
                  // height: 36.h,
                  child: Row(
                    spacing: 6.w,
                    children: [
                      if (showSearch)
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Search...',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  Assets.images.filter,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        )
                      else ...[
                        _filterType(
                          label: "Date",
                          iconPath: Assets.images.calendar,
                        ),
                        _filterType(
                          label: "Category",
                          iconPath: Assets.images.tag2,
                        ),
                        _filterType(
                          label: "Wallets",
                          iconPath: Assets.images.wallet,
                        ),
                      ],
                      IconButton(
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          backgroundColor: neutralN600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showSearch = !showSearch;
                          });
                        },
                        icon: SvgPicture.asset(
                          showSearch == true
                              ? Assets.images.close
                              : Assets.images.searchNormal,
                          width: 16.w,
                          height: 16.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                          ),
                        ),
                        position: PopupMenuPosition.under,
                        icon: Row(
                          spacing: 4.w,
                          children: [
                            Text(
                              "Export",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SvgPicture.asset(
                              Assets.images.export,
                            ),
                          ],
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              onTap: () {},
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    Assets.images.pdfType,
                                  ),
                                  const Text('To PDF'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    Assets.images.excelType,
                                  ),
                                  const Text('To Excel'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                transactions.isEmpty
                    ? SizedBox(
                        height: 0.25.sh,
                        child: Center(
                          child: Text(
                            'No transactions found',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8.h);
                        },
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return TransactionTile(
                            transaction: transaction,
                            accentColor: transaction.transaction.type ==
                                    TransactionType.income
                                ? Theme.of(context).primaryColor
                                : const Color(0xFFEB5757),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _bottomTile(
                context,
                accentColor: appPrimaryColor,
                mainText: "Total income",
                amount: 20111,
              ),
            ),
            Expanded(
              child: _bottomTile(
                context,
                accentColor: appDangerColor,
                mainText: LocaleKeys.totalExpenses.tr(),
                amount: 4220,
              ),
            ),
            Expanded(
              child: _bottomTile(
                context,
                accentColor: appBlue,
                mainText: LocaleKeys.totalBalance.tr(),
                amount: 70000,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomTile(
    BuildContext context, {
    required Color accentColor,
    required String mainText,
    required double amount,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 8.w,
      ),
      decoration: BoxDecoration(
        color: accentColor.withAlpha(40),
      ),
      child: Column(
        children: [
          Text(
            mainText,
            style: TextStyle(
              fontSize: 14.sp,
              color: neutralN700,
            ),
          ),
          Text(
            CurrencyFormater.formatAmountWithSymbol(
              context,
              currentDecimalDigits: 0,
              amount,
              compact: true,
            ),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterType({
    required String label,
    required String iconPath,
  }) {
    final GlobalKey key = GlobalKey();

    return Expanded(
      child: Builder(
        builder: (context) {
          return InkWell(
            key: key,
            onTap: () {
              showCustomPopOver(context, label: label);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: appPrimaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: appPrimaryColor,
                  width: 1.5.w,
                ),
              ),
              child: Row(
                spacing: 4.w,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    width: 12.w,
                    height: 12.h,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: neutralN900,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
