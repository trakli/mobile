import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

import 'package:trakli/presentation/widgets/image_widget.dart';

class CategoryTile extends StatefulWidget {
  final Color accentColor;
  final CategoryEntity category;
  final bool showStat;
  final bool showValue;
  final double? amount;
  final int transactionCount;
  final int walletCount;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryTile({
    super.key,
    required this.category,
    this.accentColor = const Color(0xFFEB5757),
    this.showStat = false,
    this.showValue = false,
    this.amount,
    this.transactionCount = 0,
    this.walletCount = 0,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  final int randomValue = math.Random().nextInt(5000);

  @override
  void initState() {
    super.initState();
  }

  void _showDeleteConfirmation() {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: 'Delete Category',
        subTitle:
            'Are you sure you want to delete "${widget.category.name}"? This action cannot be undone.',
        mainAction: () {
          Navigator.pop(context);
          widget.onDelete?.call();
        },
        mainActionText: "Delete",
        secondaryActionText: "Cancel",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 0.5,
          color: transactionTileBorderColor,
        ),
      ),
      padding: EdgeInsets.all(8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.w,
        children: [
          Container(
              // padding: EdgeInsets.all(2.r),
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: ImageWidget(
                  mediaEntity: widget.category.icon,
                  accentColor: widget.accentColor,
                  iconSize: 30.sp,
                  emojiSize: 30.sp,
                  placeholderIcon: Icons.category,
                ),
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF061D23),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.showStat
                              ? "${widget.transactionCount} transactions in ${widget.walletCount} wallets"
                              : widget.category.description ?? "No description",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF576760),
                          ),
                        ),
                      ],
                    ),
                    if (widget.onEdit != null || widget.onDelete != null)
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: widget.accentColor.withValues(alpha: 0.2),
                        ),
                        child: PopupMenuButton(
                          icon: SvgPicture.asset(
                            height: 20.h,
                            width: 20.w,
                            Assets.images.more,
                            colorFilter: ColorFilter.mode(
                              widget.accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          itemBuilder: (context) {
                            return [
                              if (widget.onEdit != null)
                                PopupMenuItem(
                                  onTap: widget.onEdit,
                                  height: 40.h,
                                  child: Row(
                                    spacing: 8.w,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(50),
                                        ),
                                        child: SvgPicture.asset(
                                          height: 16.h,
                                          width: 16.w,
                                          Assets.images.edit2,
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      const Text('Edit'),
                                    ],
                                  ),
                                ),
                              if (widget.onDelete != null)
                                PopupMenuItem(
                                  onTap: _showDeleteConfirmation,
                                  height: 40.h,
                                  child: Row(
                                    spacing: 8.w,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.redAccent.withAlpha(50),
                                        ),
                                        child: SvgPicture.asset(
                                          height: 16.h,
                                          width: 16.w,
                                          Assets.images.trash,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.redAccent,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      const Text('Delete'),
                                    ],
                                  ),
                                ),
                            ];
                          },
                        ),
                      )
                    else if (widget.showValue)
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: widget.accentColor,
                            fontSize: 16.sp,
                          ),
                          text:
                              widget.category.type.name == 'expense' ? "-" : "",
                          children: [
                            TextSpan(
                              text: CurrencyFormater.formatAmountWithSymbol(
                                context,
                                widget.amount ?? randomValue.toDouble(),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SvgPicture.asset(
                        Assets.images.arrowRight,
                        width: 24.w,
                        height: 24.h,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
