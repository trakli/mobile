import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_dto.dart';
import 'package:trakli/data/datasources/wallet/dtos/wallet_dto.dart';

part 'transaction_complete_dto.freezed.dart';
part 'transaction_complete_dto.g.dart';

class TransactionConverter
    implements JsonConverter<Transaction, Map<String, dynamic>> {
  const TransactionConverter();

  @override
  Transaction fromJson(Map<String, dynamic> json) {
    return Transaction.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Transaction transaction) {
    return transaction.toJson();
  }
}

class CategoryConverter
    implements JsonConverter<Category, Map<String, dynamic>> {
  const CategoryConverter();

  @override
  Category fromJson(Map<String, dynamic> json) {
    return Category.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Category category) {
    return category.toJson();
  }
}

class WalletConverter implements JsonConverter<Wallet, Map<String, dynamic>> {
  const WalletConverter();

  @override
  Wallet fromJson(Map<String, dynamic> json) {
    return Wallet.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Wallet wallet) {
    return wallet.toJson();
  }
}

class PartyConverter implements JsonConverter<Party?, Map<String, dynamic>?> {
  const PartyConverter();

  @override
  Party? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Party.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Party? party) {
    if (party == null) {
      return null;
    }
    return party.toJson();
  }
}

@freezed
@JsonSerializable(explicitToJson: true)
class TransactionCompleteDto with _$TransactionCompleteDto {
  const TransactionCompleteDto._();

  const factory TransactionCompleteDto({
    @TransactionConverter() required Transaction transaction,
    @CategoryConverter() @Default([]) List<Category> categories,
    @WalletConverter() required Wallet wallet,
    @PartyConverter() Party? party,
  }) = _TransactionCompleteDto;

  factory TransactionCompleteDto.fromTransaction({
    @TransactionConverter() required Transaction transaction,
    @CategoryConverter() @Default([]) List<Category>? categories,
    @WalletConverter() required Wallet wallet,
    @PartyConverter() Party? party,
  }) {
    return TransactionCompleteDto(
      transaction: transaction,
      categories: categories ?? [],
      wallet: wallet,
      party: party,
    );
  }

  factory TransactionCompleteDto.fromJson(Map<String, dynamic> json) {
    return _$TransactionCompleteDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TransactionCompleteDtoToJson(this);
  }

  Map<String, dynamic> toServerJson() {
    return {
      ...transaction.toJson(),
      'client_id': transaction.clientId,
      'type': transaction.type.serverKey,
      'datetime': formatServerIsoDateTimeString(transaction.datetime),
      'created_at': formatServerIsoDateTimeString(transaction.createdAt),
      'updated_at': formatServerIsoDateTimeString(transaction.updatedAt),
      'categories': categories.map((c) => c.id).toList(),
      'wallet_id': wallet.id,
      'party_id': party?.id,
    };
  }

  factory TransactionCompleteDto.fromServerJson(Map<String, dynamic> json) {
    final transactionDto = TransactionDTO.fromJson(json);

    final categories = (json['categories'] as List<dynamic>)
        .map((c) => Category.fromJson(c as Map<String, dynamic>))
        .toList();

    final wallet =
        WalletDto.fromJson(json['wallet'] as Map<String, dynamic>).toModel();

    final party = json['party'] != null
        ? Party.fromJson(json['party'] as Map<String, dynamic>)
        : null;

    final transaction = Transaction(
      amount: transactionDto.amount,
      clientId: transactionDto.clientGeneratedId,
      createdAt: DateTime.parse(transactionDto.createdAt),
      updatedAt: DateTime.parse(transactionDto.updatedAt),
      type: transactionDto.type,
      datetime: DateTime.parse(transactionDto.datetime),
      walletClientId: wallet.clientId,
      description: transactionDto.description,
      id: transactionDto.id,
      userId: transactionDto.userId,
      walletId: wallet.id,
      partyClientId: party?.clientId,
    );

    return TransactionCompleteDto(
      transaction: transaction,
      categories: categories,
      wallet: wallet,
      party: party,
    );
  }
}
