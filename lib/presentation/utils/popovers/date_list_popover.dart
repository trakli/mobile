import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/ledger/ledger_popover.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/dialogs/custom_range_picker.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class DateListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<PickerDateRange> onSelect;
  final ValueChanged<DateFilterOption> onSelectString;

  const DateListPopover({
    super.key,
    required this.label,
    required this.onSelect,
    required this.onSelectString,
  });

  @override
  Widget build(BuildContext context) {
    const options = DateFilterOption.values;
    return LedgerPopoverMenu(
      title: label,
      items: [
        for (final option in options)
          LedgerPopoverItem(
            label: option.name.tr(),
            onTap: () async {
              if (option == options.last) {
                await showCustomDialog(
                  widget: CustomRangePicker(
                    onSelect: (range) {
                      onSelect(range);
                      onSelectString(option);
                    },
                  ),
                );
              } else {
                onSelect(
                  PickerDateRange(
                    getStartDateFromKey(option.name),
                    DateTime.now(),
                  ),
                );
                onSelectString(option);
              }
              if (context.mounted) AppNavigator.pop(context);
            },
          ),
      ],
    );
  }
}
