import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/cloud_benefit_entity.dart';

abstract class CloudBenefitRepository {
  Future<Either<Failure, CloudBenefitEntity>> fetchCloudBenefits();
}
