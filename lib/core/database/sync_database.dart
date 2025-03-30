import 'dart:async';
import 'package:dio/dio.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/database/app_database.dart';
import 'package:logging/logging.dart';
import 'package:trakli/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final _logger = Logger('SynchAppDatabase');

@lazySingleton
class SynchAppDatabase extends DriftSynchronizer<AppDatabase> {
  SynchAppDatabase({
    required super.appDatabase,
    required super.typeHandlers,
    required Dio dio,
    required NetworkInfo networkInfo,
  }) {
    _dio = dio;
    _networkInfo = networkInfo;
    _startPeriodicSync();
    _setupConnectivityListener();
  }

  late final Dio _dio;
  late final NetworkInfo _networkInfo;
  Timer? _syncTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  static const _syncInterval = Duration(minutes: 5); // Sync every 5 minutes

  void _startPeriodicSync() {
    // Initial sync
    _performSync();

    // Set up periodic sync
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      _performSync();
    });
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _logger.info('Internet connection restored, triggering sync');
        _performSync();
      } else {
        _logger.info('Internet connection lost');
      }
    });
  }

  Future<void> _performSync() async {
    try {
      // Check if we have internet connectivity before attempting sync
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        _logger.warning('No internet connection available, skipping sync');
        return;
      }

      await sync();
    } catch (e, stackTrace) {
      _logger.severe('Error during sync', e, stackTrace);
      // You might want to notify the user or handle the error in some way
    }
  }

  @override
  Future<void> dispose() async {
    _syncTimer?.cancel();
    await _connectivitySubscription?.cancel();
    await super.dispose();
  }

  @override
  Future<String?> getLatestServerChangeId() async {
    try {
      final response = await _dio.get('transactions');
      return response.data['lastChangeId'];
    } catch (e, stackTrace) {
      _logger.severe('Error getting latest server change ID', e, stackTrace);
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
      _logger.severe('Error getting server pending changes', e, stackTrace);
      rethrow;
    }
  }
}
