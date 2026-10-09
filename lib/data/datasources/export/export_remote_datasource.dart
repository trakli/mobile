import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:trakli/core/error/error_handler.dart';

/// The file formats the export endpoints can produce.
enum ExportFormat {
  pdf('pdf', 'application/pdf'),
  xlsx('xlsx',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  csv('csv', 'text/csv');

  const ExportFormat(this.key, this.mimeType);

  final String key;
  final String mimeType;
}

abstract class ExportRemoteDataSource {
  /// Downloads the filtered transaction list. Filters mirror the list endpoint
  /// so the file matches what the screen is showing.
  Future<Uint8List> exportTransactions({
    required ExportFormat format,
    DateTime? from,
    DateTime? to,
    List<int> walletIds = const [],
    List<int> categoryIds = const [],
  });

  /// Downloads the financial statement for [start]..[end], built from the
  /// same figures as the stats endpoint.
  Future<Uint8List> exportStatement({
    required ExportFormat format,
    required DateTime start,
    required DateTime end,
    List<int> walletIds = const [],
  });
}

@Injectable(as: ExportRemoteDataSource)
class ExportRemoteDataSourceImpl implements ExportRemoteDataSource {
  final Dio dio;

  ExportRemoteDataSourceImpl({required this.dio});

  @override
  Future<Uint8List> exportTransactions({
    required ExportFormat format,
    DateTime? from,
    DateTime? to,
    List<int> walletIds = const [],
    List<int> categoryIds = const [],
  }) async {
    final response = await ErrorHandler.handleApiCall(
      () => dio.get<List<int>>(
        'transactions/export',
        queryParameters: {
          'format': format.key,
          if (from != null) 'date_from': _ymd(from),
          if (to != null) 'date_to': _ymd(to),
          if (walletIds.isNotEmpty) 'wallet_ids': walletIds.join(','),
          if (categoryIds.isNotEmpty) 'category_ids': categoryIds.join(','),
        },
        options: Options(responseType: ResponseType.bytes),
      ),
    );

    return Uint8List.fromList(response.data ?? []);
  }

  @override
  Future<Uint8List> exportStatement({
    required ExportFormat format,
    required DateTime start,
    required DateTime end,
    List<int> walletIds = const [],
  }) async {
    final response = await ErrorHandler.handleApiCall(
      () => dio.get<List<int>>(
        'reports/export',
        queryParameters: {
          'format': format.key,
          'start_date': _ymd(start),
          'end_date': _ymd(end),
          if (walletIds.isNotEmpty) 'wallet_ids': walletIds.join(','),
        },
        options: Options(responseType: ResponseType.bytes),
      ),
    );

    return Uint8List.fromList(response.data ?? []);
  }

  String _ymd(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
