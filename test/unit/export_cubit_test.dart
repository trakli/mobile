import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';
import 'package:trakli/domain/usecases/export/export_statement_usecase.dart';
import 'package:trakli/domain/usecases/export/export_transactions_usecase.dart';
import 'package:trakli/presentation/exports/cubit/export_cubit.dart';

class _MockExportTransactions extends Mock
    implements ExportTransactionsUseCase {}

class _MockExportStatement extends Mock implements ExportStatementUseCase {}

class _MockAuthService extends Mock implements AuthService {}

class _MockDatabase extends Mock implements AppDatabase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockExportTransactions exportTransactions;
  late _MockExportStatement exportStatement;
  late _MockAuthService authService;
  late _MockDatabase db;

  final bytes = Uint8List.fromList([1, 2, 3]);

  setUpAll(() {
    registerFallbackValue(
      const ExportTransactionsParams(format: ExportFormat.pdf),
    );
    registerFallbackValue(
      ExportStatementParams(
        format: ExportFormat.pdf,
        start: DateTime(2026),
        end: DateTime(2026),
      ),
    );
  });

  setUp(() {
    exportTransactions = _MockExportTransactions();
    exportStatement = _MockExportStatement();
    authService = _MockAuthService();
    db = _MockDatabase();

    when(() => authService.isAuthenticated()).thenAnswer((_) async => true);
    when(() => db.hasPendingTransactionChanges())
        .thenAnswer((_) async => false);
  });

  ExportCubit buildCubit() =>
      ExportCubit(exportTransactions, exportStatement, authService, db);

  test('produces a file named for the requested format', () async {
    when(() => exportTransactions(any())).thenAnswer((_) async => Right(bytes));

    final cubit = buildCubit();
    await cubit.exportTransactions(format: ExportFormat.xlsx);

    expect(cubit.state.isExporting, isFalse);
    expect(cubit.state.file, isNotNull);
    expect(cubit.state.file!.name, endsWith('.xlsx'));
    expect(cubit.state.file!.mimeType, ExportFormat.xlsx.mimeType);
    expect(cubit.state.file!.bytes, bytes);
  });

  test('forwards the active filters to the use case', () async {
    when(() => exportTransactions(any())).thenAnswer((_) async => Right(bytes));

    final from = DateTime(2026, 3, 1);
    final to = DateTime(2026, 3, 31);

    await buildCubit().exportTransactions(
      format: ExportFormat.csv,
      from: from,
      to: to,
      walletIds: const [7],
      categoryIds: const [11, 12],
    );

    final captured = verify(() => exportTransactions(captureAny()))
        .captured
        .single as ExportTransactionsParams;

    expect(captured.format, ExportFormat.csv);
    expect(captured.from, from);
    expect(captured.to, to);
    expect(captured.walletIds, [7]);
    expect(captured.categoryIds, [11, 12]);
  });

  test('refuses to export while signed out', () async {
    when(() => authService.isAuthenticated()).thenAnswer((_) async => false);

    final cubit = buildCubit();
    await cubit.exportTransactions(format: ExportFormat.pdf);

    expect(cubit.state.blocker, ExportBlocker.signedOut);
    expect(cubit.state.file, isNull);
    verifyNever(() => exportTransactions(any()));
  });

  test('refuses to export while local changes are unsynced', () async {
    when(() => db.hasPendingTransactionChanges()).thenAnswer((_) async => true);

    final cubit = buildCubit();
    await cubit.exportTransactions(format: ExportFormat.pdf);

    expect(cubit.state.blocker, ExportBlocker.pendingSync);
    expect(cubit.state.file, isNull);
    verifyNever(() => exportTransactions(any()));
  });

  test('surfaces a failure instead of a file', () async {
    when(() => exportTransactions(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    final cubit = buildCubit();
    await cubit.exportTransactions(format: ExportFormat.pdf);

    expect(cubit.state.failure, const Failure.networkError());
    expect(cubit.state.file, isNull);
    expect(cubit.state.isExporting, isFalse);
  });

  test('clearFile stops the same export being shared twice', () async {
    when(() => exportTransactions(any())).thenAnswer((_) async => Right(bytes));

    final cubit = buildCubit();
    await cubit.exportTransactions(format: ExportFormat.pdf);
    expect(cubit.state.file, isNotNull);

    cubit.clearFile();
    expect(cubit.state.file, isNull);
  });

  group('statement', () {
    test('produces a statement file for the requested range', () async {
      when(() => exportStatement(any())).thenAnswer((_) async => Right(bytes));

      final start = DateTime(2026, 7, 1);
      final end = DateTime(2026, 9, 29);

      final cubit = buildCubit();
      await cubit.exportStatement(
        format: ExportFormat.pdf,
        start: start,
        end: end,
      );

      final captured = verify(() => exportStatement(captureAny()))
          .captured
          .single as ExportStatementParams;

      expect(captured.format, ExportFormat.pdf);
      expect(captured.start, start);
      expect(captured.end, end);
      expect(cubit.state.file!.name, startsWith('statement-'));
      expect(cubit.state.file!.name, endsWith('.pdf'));
      verifyNever(() => exportTransactions(any()));
    });

    test('is held back while changes wait to sync', () async {
      when(() => db.hasPendingTransactionChanges())
          .thenAnswer((_) async => true);

      final cubit = buildCubit();
      await cubit.exportStatement(
        format: ExportFormat.xlsx,
        start: DateTime(2026, 9, 1),
        end: DateTime(2026, 9, 30),
      );

      expect(cubit.state.blocker, ExportBlocker.pendingSync);
      expect(cubit.state.file, isNull);
      verifyNever(() => exportStatement(any()));
    });
  });
}
