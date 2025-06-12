import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/forms/add_groups_form.dart';

class AddGroupScreen extends StatelessWidget {
  final GroupEntity? group;
  const AddGroupScreen({super.key, this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        headerTextColor: const Color(0xFFEBEDEC),
        titleText: LocaleKeys.groupAddGroup.tr(),
      ),
      body: AddGroupsForm(
        group: group,
      ),
    );
  }
}
