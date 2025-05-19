import 'package:flutter/material.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:trakli/data/database/app_database.dart';

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
        title: const Text('Database Viewer'),
      ),
      body: DriftDbViewer(database),
    );
  }
}
