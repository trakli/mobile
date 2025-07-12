import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class DatabaseViewer extends StatelessWidget {
  final AppDatabase database;

  const DatabaseViewer({
    super.key,
    required this.database,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.databaseViewer.tr()),
      ),
      body: DriftDbViewer(database),
    );
  }
}
