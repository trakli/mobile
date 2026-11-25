import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/category/category_detail_screen.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/category/widgets/category_list_tile.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_empty.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TransactionType _type = TransactionType.expense;
  String _query = '';

  void _add() {
    AppNavigator.push(
      context,
      AddCategoryScreen(
        accentColor: _type == TransactionType.income
            ? context.tones.incomeColor
            : context.tones.expenseColor,
        type: _type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Scaffold(
      backgroundColor: t.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.categories.tr(),
        onSearchChanged: (v) => setState(() => _query = v),
        searchHint: LocaleKeys.categoriesSearchHint.tr(),
        actions: [
          PageAppBarAction(icon: LucideIcons.plus, onTap: _add, primary: true),
        ],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.isLoading && state.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final all = state.categories;
          final q = _query.trim().toLowerCase();
          final ofType = all.where((c) => c.type == _type).toList();
          final filtered = ofType.where((c) {
            if (q.isEmpty) return true;
            return '${c.name} ${c.description ?? ''}'.toLowerCase().contains(q);
          }).toList();
          final accent =
              _type == TransactionType.income ? t.incomeColor : t.expenseColor;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 10.lx),
                child: LedgerSeg<TransactionType>(
                  options: [
                    LedgerSegOption(
                      TransactionType.expense,
                      '${LocaleKeys.transactionExpense.tr()} · ${all.where((c) => c.type == TransactionType.expense).length}',
                    ),
                    LedgerSegOption(
                      TransactionType.income,
                      '${LocaleKeys.transactionIncome.tr()} · ${all.where((c) => c.type == TransactionType.income).length}',
                    ),
                  ],
                  selected: _type,
                  onChanged: (v) => setState(() => _type = v),
                ),
              ),
              Expanded(
                child: ofType.isEmpty
                    ? InfoInterface(action: _add, data: emptyCategoryData)
                    : filtered.isEmpty
                        ? LedgerEmptyState(
                            icon: LucideIcons.searchX,
                            title: q.isEmpty
                                ? LocaleKeys.listNoMatchFilter.tr()
                                : LocaleKeys.walletsNoMatchQuery
                                    .tr(args: [_query.trim()]),
                          )
                        : ListView(
                            padding:
                                EdgeInsets.fromLTRB(14.lx, 0, 14.lx, 40.lx),
                            children: [
                              LedgerCard(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12.lx),
                                child: Column(
                                  children: [
                                    for (final c in filtered)
                                      CategoryListTile(
                                        category: c,
                                        divider: c != filtered.last,
                                        onTap: () => AppNavigator.push(
                                          context,
                                          CategoryDetailScreen(category: c),
                                        ),
                                        onEdit: () => AppNavigator.push(
                                          context,
                                          AddCategoryScreen(
                                            category: c,
                                            accentColor: accent,
                                            type: _type,
                                          ),
                                        ),
                                        onDelete: () => context
                                            .read<CategoryCubit>()
                                            .deleteCategory(c.clientId),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
