import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(LocaleKeys.otherScreen.tr()),
      ),
    );
  }
}
