import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';
import 'package:trakli/domain/repositories/onboarding_repository.dart';

@injectable
class EnsureDefaultGroupExistsUseCase
    implements UseCase<Unit, EnsureDefaultGroupParams> {
  final GroupRepository groupRepository;
  final OnboardingRepository onboardingRepository;

  EnsureDefaultGroupExistsUseCase(
    this.groupRepository,
    this.onboardingRepository,
  );

  @override
  Future<Either<Failure, Unit>> call(EnsureDefaultGroupParams params) async {
    final settingsResult = await onboardingRepository.getOnboardingState();

    return await settingsResult.fold(
      (failure) async => Left(failure),
      (settings) async {
        if (settings == null) {
          return const Left(Failure.notFound());
        }
        if (settings.defaultGroup != null) {
          return const Right(unit);
        }

        // Only fetch groups if defaultGroup is not set
        final hasAnyGroup = await groupRepository.getAllGroups();
        return hasAnyGroup.fold(
          (failure) => Left(failure),
          (groups) async {
            if (groups.isEmpty) {
              final result = await groupRepository.insertGroup(
                name: params.name,
                description: params.description,
                icon: params.icon,
              );

              return result.fold((failure) => Left(failure), (group) async {
                final updatedSettings =
                    settings.copyWith(defaultGroup: group.clientId);
                final saveResult = await onboardingRepository
                    .saveOnboardingState(updatedSettings);
                return saveResult.fold(
                  (failure) => Left(failure),
                  (_) => const Right(unit),
                );
              });
            } else {
              // Set the first group as default and save.
              final updatedSettings =
                  settings.copyWith(defaultGroup: groups.first.clientId);
              final saveResult = await onboardingRepository
                  .saveOnboardingState(updatedSettings);
              return saveResult.fold(
                (failure) => Left(failure),
                (_) => const Right(unit),
              );
            }
          },
        );
      },
    );
  }
}

class EnsureDefaultGroupParams {
  final String name;
  final String? description;
  final MediaEntity? icon;

  const EnsureDefaultGroupParams({
    required this.name,
    this.description,
    this.icon,
  });
}
