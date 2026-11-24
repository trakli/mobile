import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/space/dto/space_dtos.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';

abstract class SpaceRemoteDataSource {
  Future<SpaceListEntity> getSpaces();
  Future<SpaceEntity> createSpace({required String name, String? description});
  Future<SpaceOverviewEntity> getOverview(String slug);
  Future<SpacePage<SpaceTransactionEntity>> getTransactions(
    String slug, {
    int page = 1,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<SpaceMemberEntity>> getMembers(String slug);
  Future<SpaceTransactionEntity> shareTransaction(String slug, int id);
  Future<SpaceTransactionEntity> classifyTransaction(
    String slug,
    int id, {
    required List<int> categoryIds,
    required List<int> groupIds,
  });
  Future<SpacePage<SpaceTransactionEntity>> getBudgetTransactions(
    String slug,
    int budgetId, {
    int page = 1,
  });
  Future<void> closeBudgetPeriod(String slug, int budgetId);
  Future<SpaceInvitationEntity> previewInvitation(String token);
  Future<SpaceInvitationResult> acceptInvitation(String token);
  Future<void> declineInvitation(String token);
}

@Injectable(as: SpaceRemoteDataSource)
class SpaceRemoteDataSourceImpl implements SpaceRemoteDataSource {
  final Dio dio;

  SpaceRemoteDataSourceImpl({required this.dio});

  static final _day = DateFormat('yyyy-MM-dd');

  String _ws(String slug) => 'workspaces/${Uri.encodeComponent(slug)}';
  String _inv(String token) =>
      'workspaces/invitations/${Uri.encodeComponent(token)}';

  dynamic _data(Response<dynamic> response) =>
      ApiResponse.fromJson(response.data as Map<String, dynamic>).data;

  Map<String, dynamic> _map(Response<dynamic> response) =>
      Map<String, dynamic>.from(_data(response) as Map);

  @override
  Future<SpaceListEntity> getSpaces() {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.get('workspaces');
      return SpaceListDto.fromJson(_map(res)).toEntity();
    });
  }

  @override
  Future<SpaceEntity> createSpace({
    required String name,
    String? description,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.post('workspaces', data: {
        'name': name,
        if (description != null && description.isNotEmpty)
          'description': description,
      });
      return SpaceDto.fromJson(_map(res)).toEntity();
    });
  }

  @override
  Future<SpaceOverviewEntity> getOverview(String slug) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.get('${_ws(slug)}/finance');
      return SpaceOverviewDto.fromJson(_map(res)).toEntity();
    });
  }

  @override
  Future<SpacePage<SpaceTransactionEntity>> getTransactions(
    String slug, {
    int page = 1,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.get(
        '${_ws(slug)}/transactions',
        queryParameters: {
          'page': page,
          if (startDate != null) 'start_date': _day.format(startDate),
          if (endDate != null) 'end_date': _day.format(endDate),
        },
      );
      return SpacePageDto.transactions(_map(res));
    });
  }

  @override
  Future<List<SpaceMemberEntity>> getMembers(String slug) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.get('${_ws(slug)}/members');
      final data = _data(res);
      return data is List
          ? data
              .whereType<Map>()
              .map((m) => SpaceMemberDto.fromJson(Map<String, dynamic>.from(m)))
              .toList()
          : <SpaceMemberEntity>[];
    });
  }

  @override
  Future<SpaceTransactionEntity> shareTransaction(String slug, int id) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.post(
        '${_ws(slug)}/shares/transactions',
        data: {'transaction_id': id, 'confirmed': true},
      );
      return SpaceTransactionDto.fromJson(_map(res)).toEntity();
    });
  }

  @override
  Future<SpaceTransactionEntity> classifyTransaction(
    String slug,
    int id, {
    required List<int> categoryIds,
    required List<int> groupIds,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.put(
        '${_ws(slug)}/transactions/$id/classification',
        data: {'category_ids': categoryIds, 'group_ids': groupIds},
      );
      return SpaceTransactionDto.fromJson(_map(res)).toEntity();
    });
  }

  @override
  Future<SpacePage<SpaceTransactionEntity>> getBudgetTransactions(
    String slug,
    int budgetId, {
    int page = 1,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.get(
        '${_ws(slug)}/budgets/$budgetId/transactions',
        queryParameters: {'page': page},
      );
      return SpacePageDto.transactions(_map(res));
    });
  }

  @override
  Future<void> closeBudgetPeriod(String slug, int budgetId) {
    return ErrorHandler.handleApiCall(() async {
      await dio.post('${_ws(slug)}/budgets/$budgetId/close-period');
    });
  }

  @override
  Future<SpaceInvitationEntity> previewInvitation(String token) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.get(_inv(token));
      return SpaceInvitationDto.fromJson(_map(res));
    });
  }

  @override
  Future<SpaceInvitationResult> acceptInvitation(String token) {
    return ErrorHandler.handleApiCall(() async {
      final res = await dio.post('${_inv(token)}/accept');
      return SpaceInvitationDto.acceptedFromJson(_map(res));
    });
  }

  @override
  Future<void> declineInvitation(String token) {
    return ErrorHandler.handleApiCall(() async {
      await dio.post('${_inv(token)}/decline');
    });
  }
}
