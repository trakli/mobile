import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/usecases/wallet/add_wallet_usecase.dart';
import 'package:trakli/domain/usecases/wallet/delete_wallet_usecase.dart';
import 'package:trakli/domain/usecases/wallet/get_wallets_usecase.dart';
import 'package:trakli/domain/usecases/wallet/listen_to_wallets_usecase.dart';
import 'package:trakli/domain/usecases/wallet/update_wallet_usecase.dart';
import 'package:trakli/domain/usecases/wallet/ensure_default_wallet_exists_usecase.dart';

part 'wallet_state.dart';
part 'wallet_cubit.freezed.dart';

@injectable
class WalletCubit extends Cubit<WalletState> {
  final GetWalletsUseCase getWalletsUseCase;
  final AddWalletUseCase addWalletUseCase;
  final UpdateWalletUseCase updateWalletUseCase;
  final DeleteWalletUseCase deleteWalletUseCase;
  final ListenToWalletsUseCase listenToWalletsUseCase;
  final EnsureDefaultWalletExistsUseCase ensureDefaultWalletExistsUseCase;
  StreamSubscription? _walletSubscription;

  WalletCubit({
    required this.getWalletsUseCase,
    required this.addWalletUseCase,
    required this.updateWalletUseCase,
    required this.deleteWalletUseCase,
    required this.listenToWalletsUseCase,
    required this.ensureDefaultWalletExistsUseCase,
  }) : super(WalletState.initial()) {
    listenForChanges();
  }

  @override
  Future<void> close() {
    _walletSubscription?.cancel();
    return super.close();
  }

  Future<void> loadWallets() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));

    final result = await getWalletsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: failure,
      )),
      (wallets) => emit(state.copyWith(
        isLoading: false,
        wallets: wallets,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> ensureDefaultWallet({
    required String currencyCode,
    required WalletType type,
    required String name,
    String? description,
    MediaEntity? icon,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));

    final result = await ensureDefaultWalletExistsUseCase(
      EnsureDefaultWalletParams(
        currencyCode: currencyCode,
        name: name,
        type: type,
        description: description,
        icon: icon,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> addWallet({
    required String name,
    required WalletType type,
    required double balance,
    required String currency,
    String? description,
    MediaEntity? icon,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await addWalletUseCase(
      AddWalletUseCaseParams(
        name: name,
        type: type,
        balance: balance,
        currency: currency,
        description: description,
        icon: icon,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) => emit(
        state.copyWith(
          isSaving: false,
          failure: const Failure.none(),
        ),
      ),
    );
  }

  Future<void> updateWallet({
    required String clientId,
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
    MediaEntity? icon,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await updateWalletUseCase(
      UpdateWalletUseCaseParams(
        clientId: clientId,
        name: name,
        type: type,
        balance: balance,
        currency: currency,
        description: description,
        icon: icon,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> deleteWallet(String clientId) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));

    final result = await deleteWalletUseCase(clientId);
    result.fold(
      (failure) => emit(state.copyWith(
        isDeleting: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isDeleting: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> listenForChanges() async {
    emit(state.copyWith(isLoading: true));

    _walletSubscription = listenToWalletsUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(
          state.copyWith(
            failure: failure,
            isLoading: false,
          ),
        ),
        (wallets) => emit(
          state.copyWith(
            wallets: wallets,
            isLoading: false,
          ),
        ),
      ),
    );
  }

  void setCurrentSelectedWalletIndex(int index) {
    if (index >= 0 && index < state.wallets.length) {
      emit(state.copyWith(currentSelectedWalletIndex: index));
    }
  }

  WalletEntity? get currentSelectedWallet {
    if (state.wallets.isEmpty ||
        state.currentSelectedWalletIndex >= state.wallets.length) {
      return null;
    }
    return state.wallets[state.currentSelectedWalletIndex];
  }
}
