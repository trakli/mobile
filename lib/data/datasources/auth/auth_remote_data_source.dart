import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/auth/dto/auth_response_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthResponseDto> loginWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<AuthResponseDto> createUser({
    String? email,
    String? phone,
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
    required String name,
    required String password,
    String? email,
    String? phone,
  }) async {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone
        },
      );

      return AuthResponseDto.fromJson(response.data);
    });
  }

  @override
  Future<AuthResponseDto> loginWithPhonePassword(
      {required String phone, required String password}) {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );

      return AuthResponseDto.fromJson(response.data);
    });
  }
}
