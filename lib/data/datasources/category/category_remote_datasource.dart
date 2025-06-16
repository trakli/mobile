import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';

abstract class CategoryRemoteDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategory(int id);
  Future<Category> insertCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(int id);
}

@Injectable(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Category>> getAllCategories() async {
    final response = await dio.get('categories');

    final apiResponse = ApiResponse.fromJson(response.data);

    //Filter only client_generated_id is not null
    final paginatedResponse = PaginationResponse.fromJson(
      apiResponse.data as Map<String, dynamic>,
      (Object? json) => Category.fromJson(json! as Map<String, dynamic>),
    );

    return paginatedResponse.data;
  }

  @override
  Future<Category?> getCategory(int id) async {
    final response = await dio.get('categories/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return Category.fromJson(apiResponse.data);
  }

  @override
  Future<Category> insertCategory(Category category) async {
    final data = {
      'client_id': category.clientId,
      'type': category.type.name,
      'name': category.name,
      'description': category.description,
      if (category.icon != null) ...{
        'icon': category.icon!.content,
        'icon_type': category.icon!.type.name,
      },
      'created_at': formatServerIsoDateTimeString(category.createdAt)
    };

    final response = await dio.post(
      'categories',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    Category categoryData = Category.fromJson(apiResponse.data);

    return categoryData;
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final response = await dio.put(
      'categories/${category.id}',
      data: {
        'type': category.type.serverKey,
        'name': category.name,
        'description': category.description,
        if (category.icon != null) ...{
          'icon': category.icon!.content,
          'icon_type': category.icon!.type.name,
        }
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Category.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await dio.delete('categories/$id');
  }
}
