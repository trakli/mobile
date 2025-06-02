import 'package:currency_picker/currency_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'wallet_entity.freezed.dart';

@freezed
class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    required String clientId,
    required WalletType type,
    required String name,
    String? description,
    required double balance,
    required String currencyCode,
    required DateTime createdAt,
    int? id,
    int? userId,
    required DateTime updatedAt,
  }) = _WalletEntity;

  const WalletEntity._();

  Currency? get currency {
    return CurrencyService().findByCode(currencyCode);
  }
}
