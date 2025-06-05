// Abstract Data Source
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionCompleteDto>> getAllTransactions();
  Future<TransactionCompleteDto> getTransaction(int id);
  Future<TransactionCompleteDto> insertTransaction(
      TransactionCompleteDto transaction);
  Future<TransactionCompleteDto> updateTransaction(
      TransactionCompleteDto transaction);
  Future<void> deleteTransaction(int id);
}

@Injectable(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<TransactionCompleteDto>> getAllTransactions() async {
    final response = await dio.get('transactions');

    final apiResponse = ApiResponse.fromJson(response.data);

    final paginatedResponse 
    = PaginationResponse.fromJson(
      apiResponse.data as Map<String, dynamic>,
      (Object? json) =>
          TransactionCompleteDto.fromServerJson(json! as Map<String, dynamic>),
    );

    return paginatedResponse.data;
  }

  @override
  Future<TransactionCompleteDto> insertTransaction(
      TransactionCompleteDto transaction) async {
    final requestData = transaction.toServerJson();

    var response = await dio.post('transactions', data: requestData);

    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);

    return TransactionCompleteDto.fromServerJson(
        apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<TransactionCompleteDto> updateTransaction(
      TransactionCompleteDto transaction) async {
    var response = await dio.put(
      'transactions/${transaction.transaction.id}',
      data: transaction.toServerJson(),
    );

    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);

    return TransactionCompleteDto.fromServerJson(
        apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await dio.delete('transactions/$id');
  }

  @override
  Future<TransactionCompleteDto> getTransaction(int id) async {
    final response = await dio.get('transactions/$id');
    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);

    return TransactionCompleteDto.fromServerJson(
        apiResponse.data as Map<String, dynamic>);
  }
}
