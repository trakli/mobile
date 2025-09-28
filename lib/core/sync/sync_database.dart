import 'dart:async';
import 'package:dio/dio.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/core/network/network_info.dart';
import 'package:trakli/core/sync/network_sync_mixin.dart';
import 'package:trakli/core/utils/services/logger.dart';

@lazySingleton
class SynchAppDatabase extends DriftSynchronizer<AppDatabase>
    with NetworkSyncMixin {
  SynchAppDatabase({
    required super.appDatabase,
    required super.typeHandlers,
    required super.dependencyManager,
    required Dio dio,
    required NetworkInfo networkInfo,
    required super.requestAuthorizationService,
  }) {
    _dio = dio;
  }

  // Seconds
  int syncInterval = 60 * 5;

  final _syncStateController = StreamController<SyncState>.broadcast();

  Stream<SyncState> get syncStateStream => _syncStateController.stream;

  @override
  Future<void> Function(SyncState previous, SyncState current)?
      get onStateChanged => (previous, current) async {
            _syncStateController.add(current);
          };

  Timer? _periodicSyncTimer;

  void startPeriodicSync({Duration? interval}) {
    _periodicSyncTimer?.cancel();
    final syncDuration = interval ?? Duration(seconds: syncInterval);
    _periodicSyncTimer = Timer.periodic(syncDuration, (_) => _performSync());
  }

  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  /// Stops all synchronization activities (periodic and network sync). Call this after logout.
  Future<void> stopAllSync() async {
    logger.d('Stopping all sync');
    _syncStateController.add(const SyncState(
      isSynchronizing: false,
      cancelRequested: false,
    ));
    stopPeriodicSync();
    await disposeNetworkSync();
    cancel();
  }

  void init() {
    _performSync();
    initializeNetworkSync(_performSync);
    startPeriodicSync(); // Start periodic sync every 30 seconds
  }

  Future<void> doSync() async {
    await _performSync();
    stopPeriodicSync();
    startPeriodicSync(); // Start periodic sync every 30 seconds
  }

  late final Dio _dio;
  // late final NetworkInfo _networkInfo;

  Future<void> _performSync() async {
    try {
      await sync();
    } catch (e, stackTrace) {
      logger.e('Error during sync', error: e, stackTrace: stackTrace);
      // rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    stopPeriodicSync(); // Stop the timer on dispose
    await disposeNetworkSync();
    await super.dispose();
    await _syncStateController.close();
  }

  @override
  Future<String?> getLatestServerChangeId() async {
    try {
      final response = await _dio.get('transactions');
      return response.data['lastChangeId'];
    } catch (e, stackTrace) {
      logger.e('Error getting latest server change ID',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<ServerChange>> getServerPendingChanges(
      String? lastChangeId) async {
    try {
      final response = await _dio.get('transactions', queryParameters: {
        'lastChangeId': lastChangeId,
      });

      final changes = response.data['changes'];
      return changes.map((change) {
        return ServerChange(
          id: change['id'],
          moment: DateTime.parse(change['moment']),
          entityType: change['entity_type'],
          changedId: change['changed_id'],
          deleted: change['deleted'] ?? false,
          entity: change['entity'],
        );
      }).toList();
    } catch (e, stackTrace) {
      logger.e('Error getting server pending changes',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
