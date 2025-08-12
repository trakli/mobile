import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class CustomRangePicker extends StatefulWidget {
  final DateTime? initialFrom;
  final DateTime? initialTo;
  final ValueChanged<PickerDateRange> onSelect;

  const CustomRangePicker({
    super.key,
    this.initialFrom,
    this.initialTo,
    required this.onSelect,
  });

  @override
  State<CustomRangePicker> createState() => _CustomRangePickerState();
}

class _CustomRangePickerState extends State<CustomRangePicker> {
  PickerDateRange? range;

  @override
  void initState() {
    range = PickerDateRange(widget.initialFrom, widget.initialTo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 20.h,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 48.h,
          horizontal: 16.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Date Range",
                style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 20.h),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "From Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: range?.startDate != null
                    ? formatDate.format(range!.startDate!)
                    : "",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: range?.startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    final endDate = range?.endDate;
                    range = PickerDateRange(picked, endDate);
                  });
                }
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "To Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: range?.endDate != null
                    ? formatDate.format(range!.endDate!)
                    : "",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: range?.endDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    final startDate = range?.startDate;
                    range = PickerDateRange(startDate, picked);
                  });
                }
              },
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: range?.startDate != null && range?.endDate != null
                    ? () {
                        widget.onSelect(range!);
                        AppNavigator.pop(context);
                      }
                    : null,
                child: const Text("Apply"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
