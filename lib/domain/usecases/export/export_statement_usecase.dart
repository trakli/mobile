import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';
import 'package:trakli/domain/repositories/export_repository.dart';

@injectable
class ExportStatementUseCase
    implements UseCase<Uint8List, ExportStatementParams> {
  final ExportRepository repository;

  ExportStatementUseCase(this.repository);

  @override
  Future<Either<Failure, Uint8List>> call(ExportStatementParams params) {
    return repository.exportStatement(
      format: params.format,
      start: params.start,
      end: params.end,
      walletIds: params.walletIds,
    );
  }
}

class ExportStatementParams extends Equatable {
  final ExportFormat format;
  final DateTime start;
  final DateTime end;
  final List<int> walletIds;

  const ExportStatementParams({
    required this.format,
    required this.start,
    required this.end,
    this.walletIds = const [],
  });

  @override
  List<Object?> get props => [format, start, end, walletIds];
}
