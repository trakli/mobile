import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
// import 'package:trakli/domain/models/category.dart';

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
    return (response.data as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  @override
  Future<Category?> getCategory(int id) async {
    final response = await dio.get('categories/$id');
    if (response.data == null) return null;
    return Category.fromJson(response.data);
  }

  @override
  Future<Category> insertCategory(Category category) async {
    final response = await dio.post(
      'categories',
      data: {
        'client_id': category.clientId,
        'type': category.type,
        'name': category.name,
        'description': category.description,
        'created_at': category.createdAt.toIso8601String(),
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    Category categoryData = Category.fromJson(apiResponse.data);

    return categoryData;
    // final categoryDto = CategoryDto.fromJson(response.data);
    // return categoryDto.toDomain();
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final response = await dio.put(
      'categories/${category.id}',
      data: {
        'type': category.type,
        'name': category.name,
        'description': category.description,
      },
    );
    return Category.fromJson(response.data);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await dio.delete('categories/$id');
  }
}
