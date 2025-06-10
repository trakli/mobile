import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/widgets/categories_widget.dart';
import 'package:trakli/presentation/widgets/party_display_widget.dart';

class TransactionDetailsBottomSheet extends StatefulWidget {
  const TransactionDetailsBottomSheet({
    super.key,
    required this.transaction,
    required this.accentColor,
    required this.onDelete,
    required this.onEdit,
  });

  final TransactionCompleteEntity transaction;
  final Color accentColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  State<TransactionDetailsBottomSheet> createState() =>
      _TransactionDetailsBottomSheetState();
}

class _TransactionDetailsBottomSheetState
    extends State<TransactionDetailsBottomSheet> {
  SelectIconType? selectedIconType;

  DateFormat format = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction.transaction;
    final category = widget.transaction.categories;
    final party = widget.transaction.party;
    final wallet = widget.transaction.wallet;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            Stack(
              children: [
                Center(
                  child: Container(
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
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: const Color(0xFF1D3229).withValues(alpha: 0.12),
                      ),
                      padding: EdgeInsets.all(8.r),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 16.r,
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              CurrencyFormater.formatAmountWithSymbol(
                context,
                transaction.amount,
                compact: true,
                currency: widget.transaction.wallet.currency,
              ),
              style: TextStyle(
                color: widget.accentColor,
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              format.format(transaction.datetime),
              style: TextStyle(
                color: const Color(0xFF576760),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            if (transaction.description.isNotEmpty) ...[
              Text(
                transaction.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 12.h),
            ],
            PartyDisplayWidget(
              party: party,
              walletEntity: wallet,
              maxNameLength: 20,
              fromTextSize: 16.sp,
              labelSize: 12.sp,
              toTextSize: 14.sp,
              toIconSize: 14.w,
              maxToWidth: 0.2.sw,
            ),
            SizedBox(height: 6.h),
            CategoriesWidget(
              categories: category,
              accentColor: widget.accentColor,
              placeholderSize: 20.sp,
              emojiSize: 20.sp,
              iconSize: 20.sp,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: 16.w,
              children: [
                Expanded(
                  child: PrimaryButton(
                    onPress: () {
                      Navigator.of(context).pop();
                      widget.onEdit();
                    },
                    buttonText: "Edit",
                    backgroundColor: Theme.of(context).primaryColor,
                    iconPath: Assets.images.edit2,
                    iconColor: Colors.white,
                    textDirection: ui.TextDirection.rtl,
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    onPress: () {
                      Navigator.of(context).pop();
                      widget.onDelete();
                    },
                    buttonText: "Delete",
                    backgroundColor: expenseRed,
                    iconPath: Assets.images.trash,
                    iconColor: const Color(0xFFEB5757),
                    textDirection: ui.TextDirection.rtl,
                    buttonTextColor: const Color(0xFFEB5757),
                  ),
                ),
              ],
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }
}
