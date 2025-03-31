import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@singleton
class SyncService {
  Timer? _syncTimer;
  final List<Future<void> Function()> _syncCallbacks = [];

  void startPeriodicSync(VoidCallback callback) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      callback();
    });
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  void addSyncCallback(Future<void> Function() callback) {
    _syncCallbacks.add(callback);
  }

  void dispose() {
    stopPeriodicSync();
  }
}
