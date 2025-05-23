import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/notification_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/custom_drawer.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';
import 'package:trakli/presentation/utils/wallet_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: SvgPicture.asset(
          Assets.images.logoGreen,
          height: 38.h,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              AppNavigator.push(context, const NotificationScreen());
            },
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
              // padding: EdgeInsets.all(14.r),
              child: Icon(
                Icons.notifications,
                size: 20.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      drawer: const CustomDrawer(),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (BuildContext context, TransactionState state) {
          if (state.failure.hasError) {
            showSnackBar(
              message: state.failure.customMessage,
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final transactions = state.transactions;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 15.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WalletTile(),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.transactions.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppNavigator.push(context, const HistoryScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: seeAllBoxColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Row(
                          spacing: 8.w,
                          children: [
                            Text(
                              LocaleKeys.seeAll.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SvgPicture.asset(
                              width: 16.w,
                              height: 16.h,
                              Assets.images.arrowRight,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
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
                SizedBox(height: 28.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
