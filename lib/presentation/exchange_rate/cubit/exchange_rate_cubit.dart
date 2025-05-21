import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/usecases/exchange_rate/listen_to_exchange_rate.dart';

part 'exchange_rate_state.dart';
part 'exchange_rate_cubit.freezed.dart';

@injectable
class ExchangeRateCubit extends Cubit<ExchangeRateState> {
  final ListenExchangeRate _listenExchangeRate;
  StreamSubscription<ExchangeRateEntity>? _subscription;

  ExchangeRateCubit(this._listenExchangeRate)
      : super(const ExchangeRateState.initial()) {
    getExchangeRate();
  }

  Future<void> getExchangeRate() async {
    _subscription?.cancel();
    _subscription = _listenExchangeRate(NoParams()).listen(
      (entity) => emit(
        ExchangeRateState.success(entity),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
