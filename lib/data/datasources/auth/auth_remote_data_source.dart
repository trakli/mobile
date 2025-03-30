import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/auth/dto/auth_response_dto.dart';
import 'package:trakli/data/exceptions/server_exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> loginWithEmailPassword({
    required String email,
    required String password,
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
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return AuthResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      }

      throw ServerException(e.response?.data['message'] ?? 'Login failed');
    }
  }
}
