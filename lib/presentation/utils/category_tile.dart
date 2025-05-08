import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'dart:math' as math;


class CategoryTile extends StatefulWidget {
  final Color accentColor;
  final CategoryEntity category;
  final bool showStat;
  final bool showValue;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryTile({
    super.key,
    required this.category,
    this.accentColor = const Color(0xFFEB5757),
    this.showStat = false,
    this.showValue = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  Currency? currency;
  final int randomValue = math.Random().nextInt(5000);

  @override
  void initState() {
    currency = CurrencyService().findByCode("USD");
    super.initState();
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
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.category, // TODO: Use actual icon from category
              size: 20.sp,
              color: widget.accentColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    if (widget.onEdit != null || widget.onDelete != null)
                      Row(
                        children: [
                          if (widget.onEdit != null)
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 20.sp,
                                color: widget.accentColor,
                              ),
                              onPressed: widget.onEdit,
                            ),
                          if (widget.onDelete != null)
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20.sp,
                                color: Colors.red,
                              ),
                              onPressed: widget.onDelete,
                            ),
                        ],
                      )
                    else if (widget.showValue)
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: widget.accentColor,
                            fontSize: 16.sp,
                          ),
                          text: widget.category.type == 'expense' ? "-" : "",
                          children: [
                            TextSpan(
                              text: currency?.symbol ?? "",
                            ),
                            TextSpan(
                              text: randomValue.toString(),
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
                Text(
                  widget.showStat
                      ? "0 transactions in 2 wallets"
                      : widget.category.description ?? "No description",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF576760),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
