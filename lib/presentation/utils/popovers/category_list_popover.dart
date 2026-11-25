import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_popover.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class CategoryListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<CategoryEntity> onSelect;

  const CategoryListPopover({
    super.key,
    required this.label,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: tones.expense.accent,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return LedgerPopoverMenu(
          title: label,
          emptyText: LocaleKeys.noCategoriesFound.tr(),
          items: [
            for (final category in state.categories)
              LedgerPopoverItem(
                label: category.name,
                leading: LedgerCoin(
                  icon: LucideIcons.tag,
                  media: category.icon,
                  size: 26,
                ),
                onTap: () {
                  onSelect(category);
                  AppNavigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }
}
