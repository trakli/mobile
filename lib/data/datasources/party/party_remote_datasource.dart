import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';

abstract class PartyRemoteDataSource {
  Future<List<Party>> getAllParties();
  Future<Party?> getParty(int id);
  Future<Party> insertParty(Party party);
  Future<Party> updateParty(Party party);
  Future<void> deleteParty(int id);
}

@Injectable(as: PartyRemoteDataSource)
class PartyRemoteDataSourceImpl implements PartyRemoteDataSource {
  final Dio dio;

  PartyRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Party>> getAllParties() async {
    final response = await dio.get('parties');

    final apiResponse = ApiResponse.fromJson(response.data);

    final paginatedResponse = PaginationResponse.fromJson(
      apiResponse.data as Map<String, dynamic>,
      (Object? json) => Party.fromJson(json! as Map<String, dynamic>),
    );

    return paginatedResponse.data;
  }

  @override
  Future<Party?> getParty(int id) async {
    final response = await dio.get('parties/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return Party.fromJson(apiResponse.data);
  }

  @override
  Future<Party> insertParty(Party party) async {
    final data = {
      'client_id': party.clientId,
      'name': party.name,
      'description': party.description,
      'media': party.media?.toJson(),
      'created_at': formatServerIsoDateTimeString(party.createdAt)
    };

    final response = await dio.post(
      'parties',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Party.fromJson(apiResponse.data);
  }

  @override
  Future<Party> updateParty(Party party) async {
    final data = {
      'name': party.name,
      'description': party.description,
      'media': party.media?.toJson(),
    };

    final response = await dio.put(
      'parties/${party.id}',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Party.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteParty(int id) async {
    await dio.delete('parties/$id');
  }
}
