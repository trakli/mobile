import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger('dbsync:Synchronizer');

abstract class DriftSynchronizer<TAppDatabase extends SynchronizerDb> {
  DriftSynchronizer({
    required this.appDatabase,
    required this.typeHandlers,
    required SyncDependencyManagerBase dependencyManager,
  })  : _typeHandlers = <String, SyncTypeHandler>{
          for (final th in typeHandlers) th.entityType: th,
        },
        _dependencyManager = dependencyManager;

  SyncState _state = const SyncState.initial();
  SyncState get state => _state;

  final Set<SyncTypeHandler> typeHandlers;
  final Map<String, SyncTypeHandler> _typeHandlers;
  final TAppDatabase appDatabase;

  @protected
  final SyncDependencyManagerBase _dependencyManager;

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

      await downloadModelsWithNoClientIds();

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
        await _doOperation(localChange, handler);
        // await this.appDatabase.transaction(() async {
        //   // await appDatabase.concludeLocalChange(localChange);
        //   await _doOperation(localChange, handler);
        // });
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

  /// Downloads server changes using time-based partial resync for each model.
  ///
  /// Note: We do NOT need a global check for missing sync metadata here, because
  /// the per-model logic in _timeBasedPartialResync will handle the case where
  /// a model has never been synced (lastSyncedAt == null) and will perform a full
  /// fetch for that model only. This is more robust and allows incremental adoption
  /// of new models without requiring a full resync for all models.
  Future<void> downloadServerChanges() async {
    _logger.finest('Entered DownloadSynchronizer.sync method');

    _logger.finest('... will sync from');
    try {
      await _timeBasedPartialResync();
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (e) {
      _logger.severe('exception on downloadServerChanges: $e');
      rethrow;
    }
  }

  Future<void> downloadModelsWithNoClientIds() async {
    _logger.finest('Entered _partialSyncServerChanges');
    try {
      for (final handler in typeHandlers) {
        if (_state.cancelRequested) {
          _logger.finest('... cancel requested. Will leave.');
          throw const CancelException();
        }

        try {
          await assignClientIdsToRemoteItemsWithoutClientId(
            handler,
          );

          _logger.info('Updated the client without id');
        } on UnavailableException {
          rethrow;
        } catch (e, stack) {
          _logger.severe(
              'Error syncing model without client id with handler  [1m${handler.entityType} [0m: $e');
          _logger.severe(stack);
          rethrow;
          // Do not mark as successfully synced, and continue to next handler
        }
      }
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (ex) {
      _logger.finest('exception on _partialSyncServerChanges: $ex');
      rethrow;
    }
    _logger.finest('finished _partialSyncServerChanges with no incident');
  }

  /// PARTIAL SYNC: Assign client IDs to remote items without client ID (generic for any handler)
  Future<void> assignClientIdsToRemoteItemsWithoutClientId<T>(
    SyncTypeHandler<T, dynamic, dynamic> handler,
  ) async {
    final itemsWithoutClientId = await handler.getAllRemote(noClientId: true);

    if (itemsWithoutClientId.isEmpty) return;

    var updatedItems = <T>[];

    for (final item in itemsWithoutClientId) {
      try {
        final serverId = handler.getServerId(item);

        if (serverId == null) {
          continue;
        }

        final server = await handler.getLocalByServerId(serverId);

        if (server != null) {
          continue;
        }

        final current = await handler.assignClientId(item);
        updatedItems.add(current);
      } catch (e, stack) {
        _logger.warning('Failed to assign client ID for item: $e\n$stack');
        continue;
      }
    }

    const batchSize = 5;
    final allResponses = <T>[];

    for (int i = 0; i < updatedItems.length; i += batchSize) {
      final end = (i + batchSize < updatedItems.length)
          ? i + batchSize
          : updatedItems.length;
      final batch = updatedItems.sublist(i, end);
      final futureAwait = batch.map((entity) => handler.putRemote(entity));

      final responses = await Future.wait(futureAwait);

      allResponses.addAll(responses);

      _logger.finest('responses', responses);
    }

    await handler.upsertAllLocal(allResponses);
  }

  /// For each handler/model, checks if lastSyncedAt is null (never synced) and does a full fetch for that model only.
  /// Otherwise, fetches only changes since last sync. This is the most robust approach for incremental, model-aware sync.
  Future<void> _timeBasedPartialResync() async {
    final sw = Stopwatch();
    sw.start();
    _logger.finest('Entered _timeBasedPartialResync');
    try {
      _dependencyManager.resetSyncState();
      for (final handler in typeHandlers) {
        if (_state.cancelRequested) {
          _logger.finest('... cancel requested. Will leave.');
          throw const CancelException();
        }
        if (!_dependencyManager.canSync(handler)) continue;
        _logger.info(
            'started handler for \u001b[1m${handler.entityType}\u001b[0m');
        try {
          // 1. Get last sync time for this handler/model
          final localMeta =
              await appDatabase.getLocalSyncMetadata(handler.entityType);
          final lastSyncedAt = localMeta?.lastSyncedAt;

          // If lastSyncedAt is null, do a full fetch for this model only
          var isFull = false;
          if (lastSyncedAt == null) {
            isFull = true;
          }

          // 2. Fetch changed items from remote since last sync (or all if full)
          final changedItems = await handler.getAllRemote(
              syncedSince: isFull != true ? lastSyncedAt : null);

          if (changedItems.isEmpty) {
            _dependencyManager.markSuccessfullySynced(handler);
            continue;
          }

          // 3. Upsert those items locally (optionally in a transaction)
          await appDatabase.transaction(() async {
            if (isFull == true) {
              await handler.deleteAllLocal();
            }
            await handler.upsertAllLocal(changedItems);

            await appDatabase.updateEnityLocalSyncMetadata(
                entityType: handler.entityType,
                lastSyncedAt: handler.getlastSyncedAt(changedItems.last));
          });

          _dependencyManager.markSuccessfullySynced(handler);
          _logger.info(
              'synced \u001b[1m${handler.entityType}\u001b[0m in ${sw.elapsedMilliseconds}ms');
        } on UnavailableException {
          rethrow;
        } catch (e, stack) {
          _logger.severe('Error syncing handler ${handler.entityType}: $e');
          _logger.severe(stack);
          // Do not mark as successfully synced, and continue to next handler
        }
      }
      sw.stop();
      _logger.info(
        'synchronization terminated after taking ${sw.elapsedMilliseconds} milliseconds',
      );
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (e) {
      _logger.severe('exception on _timeBasedPartialResync: $e');
      rethrow;
    }
  }
}
