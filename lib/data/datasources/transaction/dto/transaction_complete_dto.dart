import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';

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

@freezed
@JsonSerializable(explicitToJson: true)
class TransactionCompleteDto with _$TransactionCompleteDto {
  const TransactionCompleteDto._();

  const factory TransactionCompleteDto({
    @TransactionConverter() required Transaction transaction,
    @CategoryConverter() @Default([]) List<Category> categories,
  }) = _TransactionCompleteDto;

  factory TransactionCompleteDto.fromTransaction({
    @TransactionConverter() required Transaction transaction,
    @CategoryConverter() @Default([]) List<Category>? categories,
  }) {
    return TransactionCompleteDto(
      transaction: transaction,
      categories: categories ?? [],
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
      'type': transaction.type.name,
      'datetime': formatServerIsoDateTimeString(transaction.datetime),
      'created_at': formatServerIsoDateTimeString(transaction.createdAt),
      'updated_at': formatServerIsoDateTimeString(transaction.updatedAt),
      'categories': categories.map((c) => c.id).toList(),
    };
  }

  factory TransactionCompleteDto.fromServerJson(Map<String, dynamic> json) {
    return TransactionCompleteDto(
      transaction: Transaction.fromJson(json),
      categories: List<dynamic>.from(json['categories'])
          .map((c) => Category.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
