import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
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
import 'package:trakli/presentation/utils/popovers/category_list_popover.dart';
import 'package:trakli/presentation/utils/popovers/date_list_popover.dart';
import 'package:trakli/presentation/utils/popovers/wallet_list_popover.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool showSearch = false;
  List<dynamic> selectedItems = [];
  PickerDateRange? dateRange;

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

          final transactions = selectedItems.isEmpty && dateRange == null
              ? state.transactions
              : (() {
                  final selectedCategories =
                      selectedItems.whereType<CategoryEntity>().toList();
                  final selectedWallets =
                      selectedItems.whereType<WalletEntity>().toList();

                  final hasCategoryFilter = selectedCategories.isNotEmpty;
                  final hasWalletFilter = selectedWallets.isNotEmpty;

                  return state.transactions.where((transaction) {
                    final categoryMatch = hasCategoryFilter &&
                        transaction.categories.any((cat) =>
                            selectedCategories.any((selected) =>
                                selected.clientId == cat.clientId));
                    final walletMatch = hasWalletFilter &&
                        selectedWallets.any((wallet) =>
                            wallet.clientId == transaction.wallet.clientId);

                    final dateMatch = matchTransactionDate(
                      dateRange,
                      transaction.transaction,
                    );

                    if (hasCategoryFilter && hasWalletFilter) {
                      return categoryMatch && walletMatch && dateMatch;
                    } else if (hasCategoryFilter) {
                      return categoryMatch && dateMatch;
                    } else if (hasWalletFilter) {
                      return walletMatch && dateMatch;
                    } else {
                      return dateMatch;
                    }
                  }).toList();
                })();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Column(
              children: [
                Row(
                  spacing: 4.w,
                  children: [
                    if (showSearch)
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: LocaleKeys.searchHint.tr(),
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
                    else
                      Expanded(
                        child: Row(
                          spacing: 6.w,
                          children: [
                            _filterType(
                              iconPath: Assets.images.calendar,
                              filterType: FilterType.date,
                            ),
                            _filterType(
                              iconPath: Assets.images.tag2,
                              filterType: FilterType.category,
                            ),
                            _filterType(
                              iconPath: Assets.images.wallet,
                              filterType: FilterType.wallet,
                            ),
                          ],
                        ),
                      ),
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
                            LocaleKeys.export.tr(),
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
                                Text(LocaleKeys.toPdf.tr()),
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
                                Text(LocaleKeys.toExcel.tr()),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                if (selectedItems.isNotEmpty)
                  SizedBox(
                    height: 30.h,
                    child: ListView.separated(
                      itemCount: selectedItems.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String itemName = '';
                        final item = selectedItems[index];
                        if (item is WalletEntity) {
                          itemName = item.name;
                        } else if (item is CategoryEntity) {
                          itemName = item.name;
                        } else if (item is DateFilterOption) {
                          if (item == DateFilterOption.custom) {
                            itemName = formatRange(dateRange) ?? "";
                          } else {
                            itemName = item.name.tr();
                          }
                        }

                        return _selectedItem(
                            iconPath: getIconPath(item),
                            name: itemName,
                            onTap: () {
                              setState(() {
                                selectedItems.removeAt(index);
                                if (item is DateFilterOption) {
                                  dateRange = null;
                                }
                              });
                            });
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 6.w);
                      },
                    ),
                  ),
                SizedBox(height: 16.h),
                transactions.isEmpty
                    ? SizedBox(
                        height: 0.25.sh,
                        child: Center(
                          child: Text(
                            LocaleKeys.noTransactionsFound.tr(),
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
                mainText: LocaleKeys.totalIncome.tr(),
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
    required String iconPath,
    required FilterType filterType,
  }) {
    final GlobalKey key = GlobalKey();

    return Expanded(
      child: Builder(
        builder: (context) {
          return OutlinedButton.icon(
            key: key,
            onPressed: () {
              showCustomPopOver(
                context,
                maxWidth: filterType == FilterType.date ? 0.45.sw : null,
                widget: filterType == FilterType.wallet
                    ? WalletListPopover(
                        label: filterType.filterName,
                        onSelect: (wallet) {
                          setState(() {
                            if (!selectedItems.any((item) =>
                                (item is WalletEntity &&
                                    item.clientId == wallet.clientId))) {
                              selectedItems.add(wallet);
                            }
                          });
                        },
                      )
                    : filterType == FilterType.category
                        ? CategoryListPopover(
                            label: filterType.filterName,
                            onSelect: (category) {
                              setState(() {
                                if (!selectedItems.any((item) =>
                                    (item is CategoryEntity &&
                                        item.clientId == category.clientId))) {
                                  selectedItems.add(category);
                                }
                              });
                            },
                          )
                        : DateListPopover(
                            label: filterType.filterName,
                            onSelect: (range) {
                              setState(() {
                                dateRange = range;
                              });
                            },
                            onSelectString: (dateFilterOption) {
                              setState(() {
                                selectedItems.removeWhere(
                                    (item) => item is DateFilterOption);
                                selectedItems.add(dateFilterOption);
                              });
                            },
                          ),
              );
            },
            icon: SvgPicture.asset(
              iconPath,
              width: 12.w,
              height: 12.h,
            ),
            label: Text(
              filterType.filterName,
              style: TextStyle(
                fontSize: 10.sp,
                color: neutralN900,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }

  Widget _selectedItem({
    String? iconPath,
    required String name,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 4.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              width: 16.w,
              height: 16.h,
              iconPath,
            ),
          Text(
            name,
            style: TextStyle(
              fontSize: 10.sp,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: SvgPicture.asset(
              Assets.images.close,
              colorFilter: const ColorFilter.mode(
                Colors.redAccent,
                BlendMode.srcIn,
              ),
            ),
          )
        ],
      ),
    );
  }
}
