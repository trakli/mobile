import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/services/logger.dart';
import 'sync_timing.dart';

mixin NetworkSyncMixin {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isConnected = false;
  final _syncTiming = SyncTiming();

  void initializeNetworkSync(Future<void> Function() syncFunction) {
    _setupConnectivityListener(syncFunction);
    // _syncTiming.scheduleSync(syncFunction);
  }

  void _setupConnectivityListener(Future<void> Function() syncFunction) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      final wasConnected = _isConnected;

      _isConnected = result != ConnectivityResult.none;

      if (!wasConnected && _isConnected) {
        logger.info('Internet connectivity restored');
        _syncTiming.resetTiming();
        await performSync(syncFunction);
      } else if (!_isConnected) {
        logger.info('Internet connectivity lost');
        _syncTiming.increaseDelay();
        _syncTiming.scheduleSync(syncFunction);
      }
    });
  }

  Future<void> performSync(Future<void> Function() syncFunction) async {
    if (!_isConnected) {
      logger.warning('Cannot sync: No internet connection');
      return;
    }

    try {
      await syncFunction();
      _syncTiming.resetTiming();
    } catch (e) {
      logger.e('Sync failed: $e');
      _syncTiming.increaseDelay();
      _syncTiming.scheduleSync(syncFunction);
    }
  }

  Future<void> disposeNetworkSync() async {
    await _connectivitySubscription?.cancel();
    _syncTiming.cancelSync();
  }
}
