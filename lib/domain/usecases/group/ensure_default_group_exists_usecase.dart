import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';
import 'package:trakli/domain/repositories/onboarding_repository.dart';

@injectable
class EnsureDefaultWalletExistsUseCase
    implements UseCase<Unit, EnsureDefaultGroupParams> {
  final GroupRepository groupRepository;
  final OnboardingRepository onboardingRepository;

  EnsureDefaultWalletExistsUseCase(
    this.groupRepository,
    this.onboardingRepository,
  );

  @override
  Future<Either<Failure, Unit>> call(EnsureDefaultGroupParams params) async {
    final hasGroup = await groupRepository.hasAnyWallet();

    return hasGroup.fold(
      (failure) => Left(failure),
      (hasWallet) async {
        if (!hasWallet) {
          final result = await groupRepository.insertGroup(
            name: params.name,
            description: params.description,
            icon: params.icon,
          );

          return result.fold((failure) => Left(failure), (group) async {
            final settingsResult =
                await onboardingRepository.getOnboardingState();

            return await settingsResult.fold(
              (failure) async => Left(failure),
              (settings) async {
                if (settings == null) {
                  return const Left(Failure.notFound());
                }
                final updatedSettings =
                    settings.copyWith(defaultGroup: group.clientId);
                final saveResult = await onboardingRepository
                    .saveOnboardingState(updatedSettings);
                return saveResult.fold(
                  (failure) => Left(failure),
                  (_) => const Right(unit),
                );
              },
            );
          });
        }

        return const Right(unit);
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
