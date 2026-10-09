import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';
import 'package:trakli/domain/usecases/export/export_statement_usecase.dart';
import 'package:trakli/domain/usecases/export/export_transactions_usecase.dart';

part 'export_state.dart';
part 'export_cubit.freezed.dart';

/// Downloads a server-rendered transaction export. The file is produced by the
/// API rather than on the device, so the export is refused while the account is
/// signed out or while local changes are still waiting to sync. Otherwise the
/// user would share a file that silently omits what they just entered.
@injectable
class ExportCubit extends Cubit<ExportState> {
  final ExportTransactionsUseCase _exportTransactions;
  final ExportStatementUseCase _exportStatement;
  final AuthService _authService;
  final AppDatabase _db;

  ExportCubit(
    this._exportTransactions,
    this._exportStatement,
    this._authService,
    this._db,
  ) : super(const ExportState());

  Future<void> exportTransactions({
    required ExportFormat format,
    DateTime? from,
    DateTime? to,
    List<int> walletIds = const [],
    List<int> categoryIds = const [],
  }) {
    return _export(
      format: format,
      baseName: 'transactions',
      download: () => _exportTransactions(ExportTransactionsParams(
        format: format,
        from: from,
        to: to,
        walletIds: walletIds,
        categoryIds: categoryIds,
      )),
    );
  }

  /// Downloads the financial statement covering [start]..[end].
  Future<void> exportStatement({
    required ExportFormat format,
    required DateTime start,
    required DateTime end,
    List<int> walletIds = const [],
  }) {
    return _export(
      format: format,
      baseName: 'statement',
      download: () => _exportStatement(ExportStatementParams(
        format: format,
        start: start,
        end: end,
        walletIds: walletIds,
      )),
    );
  }

  Future<void> _export({
    required ExportFormat format,
    required String baseName,
    required Future<Either<Failure, Uint8List>> Function() download,
  }) async {
    if (state.isExporting) return;

    emit(state.copyWith(
      inProgress: format,
      failure: const Failure.none(),
      file: null,
      blocker: ExportBlocker.none,
    ));

    if (!await _authService.isAuthenticated()) {
      emit(state.copyWith(inProgress: null, blocker: ExportBlocker.signedOut));
      return;
    }

    if (await _db.hasPendingTransactionChanges()) {
      emit(
          state.copyWith(inProgress: null, blocker: ExportBlocker.pendingSync));
      return;
    }

    final result = await download();

    result.fold(
      (failure) => emit(state.copyWith(inProgress: null, failure: failure)),
      (bytes) => emit(state.copyWith(
        inProgress: null,
        file: ExportedFile(
          bytes: bytes,
          name: _fileName(baseName, format),
          mimeType: format.mimeType,
        ),
      )),
    );
  }

  /// Clears the produced file once it has been handed to the share sheet, so a
  /// rebuild does not open it a second time.
  void clearFile() => emit(state.copyWith(file: null));

  String _fileName(String baseName, ExportFormat format) {
    final stamp = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return '$baseName-$stamp.${format.key}';
  }
}
