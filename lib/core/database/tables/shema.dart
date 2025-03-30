import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:drift/drift.dart';

mixin SyncTable on Table {
  // Add any common columns needed for sync
  TextColumn get rev => text().withDefault(const Constant('1'))();

  // You can add other common sync columns if needed
  // DateTimeColumn get lastUpdated => dateTime().nullable()();
}

