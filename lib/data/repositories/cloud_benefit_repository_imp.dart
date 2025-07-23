import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/benefits/cloud_benefit_remote_data_source.dart';
import 'package:trakli/domain/entities/cloud_benefit_entity.dart';

abstract class CloudBenefitRepository {
  Future<Either<Failure, CloudBenefitEntity>> fetchCloudBenefits();
}


@Singleton(as: CloudBenefitRepository)
class CloudBenefitRepositoryImpl implements CloudBenefitRepository {
  final CloudBenefitRemoteDataSource _remoteDataSource;

  CloudBenefitRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, CloudBenefitEntity>> fetchCloudBenefits() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final response = await _remoteDataSource.fetchCloudBenefits();
      return response.toEntity();
    });
  }
}
