import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';

abstract class GroupRemoteDataSource {
  Future<List<Group>> getAllGroups();
  Future<Group> getGroup(int id);
  Future<Group> insertGroup(Group group);
  Future<Group> updateGroup(Group group);
  Future<void> deleteGroup(int int);
}

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final Dio dio;

  GroupRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Group>> getAllGroups() async {
    final response = await dio.get('groups');

    final apiResponse = ApiResponse.fromJson(response.data);

    //Filter only client_generated_id is not null
    final paginatedResponse = PaginationResponse.fromJson(
      apiResponse.data as Map<String, dynamic>,
      (Object? json) => Group.fromJson(json! as Map<String, dynamic>),
    );

    return paginatedResponse.data;
  }

  @override
  Future<Group> getGroup(int id) async {
    final response = await dio.get('groups/$id');
    final apiResponse = ApiResponse.fromJson(response.data);
    return Group.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<Group> insertGroup(Group group) async {
    final response = await dio.post('groups', data: {
      'name': group.name,
      'description': group.description,
      if (group.icon != null) ...{
        'icon': group.icon?.content,
        'icon_type': group.icon?.type.name,
      },
      'client_id': group.clientId,
      'created_at': formatServerIsoDateTimeString(DateTime.now()),
    });
    final apiResponse = ApiResponse.fromJson(response.data);
    return Group.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<Group> updateGroup(Group group) async {
    final response = await dio.put('groups/${group.clientId}', data: {
      'name': group.name,
      'description': group.description,
      if (group.icon != null) ...{
        'icon': group.icon!.content,
        'icon_type': group.icon!.type.name,
      }
    });
    final apiResponse = ApiResponse.fromJson(response.data);
    return Group.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteGroup(int id) async {
    await dio.delete('groups/$id');
  }
}
