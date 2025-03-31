import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/auth/dto/auth_response_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthResponseDto> createUser({
    required String email,
    required String password,
    required String name,
  });
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponseDto> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return AuthResponseDto.fromJson(response.data);
    });
  }

  @override
  Future<AuthResponseDto> createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      return AuthResponseDto.fromJson(response.data);
    });
  }
}
