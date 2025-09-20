import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/add_transaction_form_compact_layout.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/forms/add_transaction_form.dart';
import 'package:trakli/providers/local_storage.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;
  final TransactionCompleteEntity? transaction;
  final WalletEntity? selectedWallet;

  const AddTransactionScreen({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
    this.transaction,
    this.selectedWallet,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String? formDisplay = LocaleKeys.full.tr();

  @override
  void initState() {
    super.initState();
    LocalStorage().getTransactionFormDisplay().then((val) {
      setState(() {
        formDisplay = val;
      });
    });

    final controlLenght = widget.transaction != null ? 1 : 2;

    tabController = TabController(length: controlLenght, vsync: this);
    if (widget.transaction != null) {
      tabController.index = 0;
    }
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        headerTextColor: const Color(0xFFEBEDEC),
        titleText: widget.transaction != null
            ? LocaleKeys.editTransaction.tr()
            : LocaleKeys.addTransaction.tr(),
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicator: BoxDecoration(
                color: (tabController.index != 0)
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : const Color(0xFFEB5757).withValues(alpha: 0.15),
                border: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: (tabController.index != 0)
                        ? Theme.of(context).primaryColor
                        : const Color(0xFFEB5757),
                  ),
                )),
            unselectedLabelStyle: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF1D3229),
            ),
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D3229),
            ),
            tabs: [
              if (widget.transaction == null ||
                  widget.transaction!.transaction.type ==
                      TransactionType.expense)
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4.w,
                    children: [
                      SvgPicture.asset(
                        Assets.images.arrowSwapUp,
                        colorFilter: ColorFilter.mode(
                          (tabController.index != 0)
                              ? Colors.black
                              : const Color(0xFFEB5757),
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(LocaleKeys.transactionExpense.tr())
                    ],
                  ),
                ),
              if (widget.transaction == null ||
                  widget.transaction!.transaction.type ==
                      TransactionType.income)
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4.w,
                    children: [
                      SvgPicture.asset(
                        Assets.images.arrowSwapDown,
                        colorFilter: ColorFilter.mode(
                          (tabController.index == 1)
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(LocaleKeys.transactionIncome.tr())
                    ],
                  ),
                ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (widget.transaction == null ||
                    widget.transaction!.transaction.type ==
                        TransactionType.expense)
                  (formDisplay == 'full'
                      ? AddTransactionForm(
                          transactionType: TransactionType.expense,
                          accentColor: Theme.of(context).primaryColor,
                          transactionCompleteEntity: widget.transaction,
                          selectedWallet: widget.selectedWallet,
                        )
                      : AddTransactionFormCompactLayout(
                          transactionType: TransactionType.expense,
                          accentColor: Theme.of(context).primaryColor,
                          transactionCompleteEntity: widget.transaction,
                          selectedWallet: widget.selectedWallet,
                        )),
                if (widget.transaction == null ||
                    widget.transaction!.transaction.type ==
                        TransactionType.income)
                  (formDisplay == 'full'
                      ? AddTransactionForm(
                          accentColor: Theme.of(context).primaryColor,
                          transactionCompleteEntity: widget.transaction,
                          selectedWallet: widget.selectedWallet,
                        )
                      : AddTransactionFormCompactLayout(
                          accentColor: Theme.of(context).primaryColor,
                          transactionCompleteEntity: widget.transaction,
                          selectedWallet: widget.selectedWallet,
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
