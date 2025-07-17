import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/transaction_details_bottom_sheet.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/dialogs.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/categories_widget.dart';
import 'package:trakli/presentation/widgets/party_display_widget.dart';

class TransactionTile extends StatefulWidget {
  final TransactionCompleteEntity transaction;
  final Color accentColor;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.accentColor = const Color(0xFFEB5757),
  });

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  DateFormat format = DateFormat('dd/MM/yyyy');

  void _handleEdit() {
    AppNavigator.push(
        context,
        AddTransactionScreen(
          transaction: widget.transaction,
          transactionType: widget.transaction.transaction.type,
          accentColor: widget.accentColor,
        ));
  }

  void _handleViewDetails() {
    showCustomBottomSheet(
      context,
      widget: TransactionDetailsBottomSheet(
        transaction: widget.transaction,
        accentColor: widget.accentColor,
        onDelete: _handleDelete,
        onEdit: _handleEdit,
      ),
    );
  }

  void _handleDelete() async {
    final shouldDelete = await showDeleteConfirmationDialog(
      context,
      title: LocaleKeys.deleteTransaction.tr(),
      message: LocaleKeys.deleteTransactionConfirmation.tr(),
    );

    if (shouldDelete) {
      if (!mounted) return;
      context.read<TransactionCubit>().deleteTransaction(
            widget.transaction.transaction.clientId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction.transaction;
    final categories = widget.transaction.categories;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 0.5,
          color: transactionTileBorderColor,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.r),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 4.w,
        isThreeLine: true,
        minVerticalPadding: 8.h,
        onTap: _handleViewDetails,
        leading: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: transaction.type == TransactionType.income
                ? transactionTileIncomeColor
                : transactionTileExpenseColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SvgPicture.asset(
            transaction.type == TransactionType.income
                ? Assets.images.arrowSwapDown
                : Assets.images.arrowSwapUp,
            width: 20.r,
            height: 20.r,
            colorFilter: ColorFilter.mode(
              widget.accentColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2.h,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PartyDisplayWidget(
                  party: widget.transaction.party,
                  walletEntity: widget.transaction.wallet,
                ),
                Column(
                  children: [
                    Text(
                      CurrencyFormater.formatAmountWithSymbol(
                        context,
                        transaction.amount,
                        compact: true,
                        currency: widget.transaction.wallet.currency,
                      ),
                      style: TextStyle(
                        color: widget.accentColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              spacing: 2.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 0.45.sw,
                  child: Text(
                    transaction.description.isNotEmpty
                        ? transaction.description
                        : LocaleKeys.noDescription.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: transactionTileTextColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  format.format(transaction.datetime),
                  style: TextStyle(
                    color: const Color(0xFF576760),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 4.h),
          child: CategoriesWidget(
            categories: categories,
            accentColor: widget.accentColor,
          ),
        ),
      ),
    );
  }
}
