// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_complete_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCompleteDto _$TransactionCompleteDtoFromJson(
        Map<String, dynamic> json) =>
    TransactionCompleteDto(
      transaction: const TransactionConverter()
          .fromJson(json['transaction'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>)
          .map((e) =>
              const CategoryConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionCompleteDtoToJson(
        TransactionCompleteDto instance) =>
    <String, dynamic>{
      'transaction': const TransactionConverter().toJson(instance.transaction),
      'categories':
          instance.categories.map(const CategoryConverter().toJson).toList(),
    };
