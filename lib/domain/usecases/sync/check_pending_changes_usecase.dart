import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/database/app_database.dart';

@injectable
class CheckPendingChangesUsecase implements UseCase<bool, NoParams> {
  final AppDatabase _appDatabase;

  CheckPendingChangesUsecase(this._appDatabase);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final pendingChanges = await _appDatabase.getPendingLocalChanges();
      // Return true if there are pending changes (items need to be synchronized)
      return Right(
          pendingChanges.where((change) => change.error == null).isNotEmpty);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
