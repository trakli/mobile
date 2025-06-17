import 'package:flutter/material.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/forms/add_groups_form.dart';

class FormDialog extends StatelessWidget {
  final GroupEntity? group;
  const FormDialog({super.key, this.group});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                AppNavigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ),
          AddGroupsForm(
            group: group,
          ),
        ],
      ),
    );
  }
}
