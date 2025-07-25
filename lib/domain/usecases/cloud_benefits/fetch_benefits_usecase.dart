import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/cloud_benefit_entity.dart'
    show CloudBenefitEntity;
import 'package:trakli/domain/repositories/cloud_benefit_repository.dart';

@injectable
class FetchBenefits implements UseCase<CloudBenefitEntity, NoParams> {
  final CloudBenefitRepository _repository;

  FetchBenefits(this._repository);

  @override
  Future<Either<Failure, CloudBenefitEntity>> call(NoParams params) {
    return _repository.fetchCloudBenefits();
  }
}
