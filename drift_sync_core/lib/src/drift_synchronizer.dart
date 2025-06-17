import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger('dbsync:Synchronizer');

abstract class DriftSynchronizer<TAppDatabase extends SynchronizerDb> {
  DriftSynchronizer({required this.appDatabase, required this.typeHandlers})
      : _typeHandlers = <String, SyncTypeHandler>{
          for (final th in typeHandlers) th.entityType: th,
        };

  SyncState _state = const SyncState.initial();
  SyncState get state => _state;

  final Set<SyncTypeHandler> typeHandlers;
  final Map<String, SyncTypeHandler> _typeHandlers;
  final TAppDatabase appDatabase;

  /// Gets the Id of the latest available change from the server.
  @protected
  Future<String?> getLatestServerChangeId();

  /// Gets the pending changes from the server, starting
  /// with lastChangeId.
  /// Will return an empty stream if no changes are available,
  /// but lastChangeId still exists in the change log.
  /// Will return null if lastChangeId has expired and removed from the
  /// change log.
  @protected
  Future<List<ServerChange>> getServerPendingChanges(String? lastChangeId);

  @protected
  Future<void> Function()? get onStarted => null;

  @protected
  Future<void> Function(SyncState state)? get onStopped => null;

  @protected
  Future<void> Function()? get onCancelRequested => null;

  @protected
  Future<void> Function(SyncState previous, SyncState current)?
      get onStateChanged => null;

  /// Called when the synchronizer is being disposed.
  /// Override this method to clean up any resources.
  Future<void> dispose() async {
    // Default implementation does nothing
  }

  Future<void> _updateState(SyncState state) async {
    final previous = this._state;
    if (previous == state) {
      return;
    }
    this._state = state;
    if (!previous.isSynchronizing && state.isSynchronizing) {
      this.onStarted?.call();
    }
    if (!previous.cancelRequested && state.cancelRequested) {
      this.onCancelRequested?.call();
    }
    if (previous.isSynchronizing && !state.isSynchronizing) {
      this.onStopped?.call(state);
    }

    this.onStateChanged?.call(previous, state);
  }

  /// Synchronizes pending local changes to the server and tries
  /// to do sync the pending changes from the server to the app.
  /// When it is not possible to do a consistent synchronization
  /// of the pending  changes from the server, reverts to a
  /// full synchronization from the server.
  Future<void> sync() async {
    _preventConcurrentSync();
    _updateState(state.start());
    try {
      final concluded = await uploadLocalChanges();
      if (!concluded) {
        // this means we weren't able to sync all local changes
        // due to an unavailable server
        return;
      }
      await downloadServerChanges();
    } finally {
      _updateState(state.stop());
    }
  }

  void cancel() {
    _updateState(state.cancel());
  }

  void _preventConcurrentSync() {
    if (state.isSynchronizing) {
      throw const InvalidStateException(
        message: "there is another synchronization already running",
      );
    }
  }

  /**********************************
   *      Upload Synchronization    *
   **********************************/

  /// synchronizes all local changes to the server
  /// Returns a list of local changes that were discarded
  /// because of optimistic conflict
  Future<bool> uploadLocalChanges() async {
    final localChanges = await appDatabase.getPendingLocalChanges();

    for (final localChange in localChanges) {
      if (_state.cancelRequested) {
        break;
      }
      final handler = _getTypeHandlerByTypeName(localChange.entityType);

      try {
        await this.appDatabase.transaction(() async {
          // await appDatabase.concludeLocalChange(localChange);
          await _doOperation(localChange, handler);
        });
      } on UnavailableException catch (_) {
        // in case we couldn't reach the server, let's just quit here and
        // report we aren't able to continue
        return false;
      } catch (ex) {
        // in case the server reported some error, let's register
        // that and continue with the other local changes.
        await appDatabase.concludeLocalChange(localChange, error: ex);
      }
    }

    // concluded everything
    return true;
  }

  Future<void> _doOperation(
    PendingLocalChange localChange,
    SyncTypeHandler<dynamic, dynamic, dynamic> handler,
  ) async {
    final entity = await handler.unmarshal(localChange.data);
    if (localChange.deleted) {
      // For delete operations, try to use server ID if available
      final serverId = handler.getServerId(entity);
      if (serverId != null) {
        await handler.deleteRemote(entity);
      }
    } else {
      // For put operations, try to use server ID if available
      final serverId = handler.getServerId(entity);

      if (!handler.shouldPersistRemote(entity)) {
        return;
      }

      if (serverId != null) {
        final updated = await handler.putRemote(entity);
        await handler.upsertLocal(updated);
      } else {
        // If no server ID, this is a new entity
        final updated = await handler.putRemote(entity);
        await handler.upsertLocal(updated);
      }
    }

    await appDatabase.concludeLocalChange(localChange, persistedToRemote: true);
  }

  SyncTypeHandler _getTypeHandlerByTypeName(String typeName) {
    final handler = _typeHandlers[typeName];
    if (handler == null) {
      throw ArgumentError(
        "There is no handler registered for the entity's type",
        'entity',
      );
    }
    return handler;
  }

  /**********************************
   *      Download Synchronization    *
   **********************************/

  /// tries to do a partial synchronization from the server,
  /// but falls back to full synchronization when needed
  Future<void> downloadServerChanges() async {
    _logger.finest('Entered DownloadSynchronizer.sync method');
    final lastChangeId = await this.appDatabase.getLastChangeId();

    if (lastChangeId == null) {
      _logger.finest('... no lastChangeId, so will do full resync');
      await _fullResync();
      return;
    }
    _logger.finest('... will sync from $lastChangeId');
    try {
      final changes = await getServerPendingChanges(
        lastChangeId == '' ? null : lastChangeId,
      );
      await _partialSyncServerChanges(changes);
    } on NotFoundException catch (_) {
      _logger.finest('...Received a NotFoundException, so doing a fullResync');
      await _fullResync();
    }
  }

  Future<void> _partialSyncServerChanges(List<ServerChange> changes) async {
    _logger.finest('Entered _partialSyncServerChanges');
    try {
      await appDatabase.transaction(() async {
        ServerChange? lastChange;

        int cnt = 0;
        for (final change in changes) {
          if (_state.cancelRequested) {
            _logger.finest('... cancel requested. Leaving');
            throw const CancelException();
          }
          if ((++cnt % 10000) == 0) {
            _logger.finest('synching ${cnt}th item of ${change.entityType}');
          }
          final handler = _getTypeHandlerByTypeName(change.entityType);

          if (change.deleted) {
            final entity = await handler.unmarshal(change.entity);
            final serverId = handler.getServerId(entity);
            if (serverId != null) {
              await handler.deleteLocal(entity);
            }
          } else {
            final entity = await handler.unmarshal(change.entity);
            await handler.upsertLocal(entity);
          }

          lastChange = change;
        }
        _logger.finest('... received all changes.');
        if (lastChange != null) {
          _logger.finest(
            '... will setLastReceivedChangeId to ${lastChange.id}',
          );

          final lcId = lastChange.id;
          await appDatabase.setLastReceivedChangeId(lcId);
        }
      });
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (ex) {
      _logger.finest('exception on _partialSyncServerChanges: $ex');
      rethrow;
    }
    _logger.finest('finished _partialSyncServerChanges with no incident');
  }

  Future<void> _fullResync() async {
    final sw = Stopwatch();
    sw.start();
    _logger.finest('Entered fullResync');
    try {
      // First, fetch all remote data outside the transaction
      final Map<SyncTypeHandler, List<dynamic>> remoteData = {};
      for (final handler in _typeHandlers.values) {
        if (_state.cancelRequested) {
          _logger.finest('... cancel requested. Will leave.');
          throw const CancelException();
        }
        _logger.info('started handler for ${handler.entityType}');

        final list = await handler.getAllRemote();
        remoteData[handler] = list;
        _logger.info('got all ${sw.elapsedMilliseconds}');
      }

      // Now perform database operations in a single transaction
      await appDatabase.transaction(() async {
        // Cancel all local changes
        await appDatabase.cancelAllLocalChanges();
        _logger.finest('... will reset last received changedId to null');
        await appDatabase.setLastReceivedChangeId(null);
        _logger.finest('... will clear all local records');

        // Clear ALL local records for ALL handlers
        for (final handler in _typeHandlers.values) {
          _logger.finest(
            '... will clear local records for handler ${handler.toString()}',
          );
          await handler.deleteAllLocal();
        }

        // Insert all remote data
        for (final entry in remoteData.entries) {
          final handler = entry.key;
          final list = entry.value;

          if (_state.cancelRequested) {
            _logger.finest('... cancel requested. Will leave.');
            throw const CancelException();
          }

          await handler.upsertAllLocal(list);
          _logger.info('called insertAll ${sw.elapsedMilliseconds}');
          _logger.info(
            'synced ${handler.toString()} ${sw.elapsedMilliseconds}',
          );
        }

        await appDatabase.setLastReceivedChangeId(null);
      });

      sw.stop();
      _logger.info(
        'synchronization terminated after taking ${sw.elapsedMilliseconds} milliseconds',
      );
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (e) {
      _logger.severe('exception on fullResync: $e');
      rethrow;
    }
  }
}
