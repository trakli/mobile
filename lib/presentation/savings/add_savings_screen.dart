import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/forms/add_savings_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class AddSavingsScreen extends StatelessWidget {
  const AddSavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        headerTextColor: const Color(0xFFEBEDEC),
        titleText: LocaleKeys.addSaving.tr(),
      ),
      body: const AddSavingsForm(),
    );
  }
}
