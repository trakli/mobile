import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/di/injection.dart';
import 'dart:async';

@injectable
class SyncCubit extends Cubit<bool> {
  late final SynchAppDatabase _syncDb;
  late final Stream<SyncState> _syncStateStream;
  late final StreamSubscription _subscription;

  SyncCubit() : super(false) {
    _syncDb = getIt<SynchAppDatabase>();
    _syncStateStream = _syncDb.syncStateStream;
    _subscription = _syncStateStream.listen((syncState) {
      emit(syncState.isSynchronizing);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
