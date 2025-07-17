import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/wallet_tile.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final exchangeRateEntity =
            context.read<ExchangeRateCubit>().state.entity;
        // Calculate total balance
        final totalBalance = state.wallets.fold<double>(0, (sum, wallet) {
          final amount = CurrencyFormater.convertAmountFromDefault(
            wallet.balance,
            wallet.currency,
            exchangeRateEntity,
            useDefaultCurrency: true,
          );

          return sum + amount;
        });

        return Scaffold(
          appBar: CustomAppBar(
            titleText: LocaleKeys.wallet.tr(),
            actions: [
              GestureDetector(
                onTap: () {
                  AppNavigator.push(context, const AddWalletScreen());
                },
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 20.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      Text(
                        LocaleKeys.totalBalance.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        LocaleKeys.balanceAmountWithCurrency.tr(
                          args: [
                            CurrencyFormater.formatAmountWithSymbol(
                              context,
                              totalBalance,
                            )
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: state.wallets.isEmpty
                            ? Center(
                                child: Text(
                                  LocaleKeys.noWalletsYet.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final wallet = state.wallets[index];
                                  return WalletTile(wallet: wallet);
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 16.h);
                                },
                                itemCount: state.wallets.length,
                              ),
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
