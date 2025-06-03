import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/enums.dart';

class PopUpDialog extends StatelessWidget {
  final DialogType dialogType;

  const PopUpDialog({
    super.key,
    this.dialogType = DialogType.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

        ],
      ),
    );
  }
}
