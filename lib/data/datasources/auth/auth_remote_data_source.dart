import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/auth/dto/auth_response_dto.dart';
import 'package:trakli/data/datasources/core/api_response.dart';

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
    required String firstName,
    String? lastName,
    required String email,
    String? username,
    String? phone,
    required String password,
  });

  Future<ApiResponse> passwordResetCode({
    required String email,
  });

  Future<ApiResponse> passwordReset({
    required String email,
    required int code,
    required String newPassword,
    required String newPasswordConfirmation,
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
        '/login',
        data: {'email': email, 'password': password},
      );

      final apiResponse = ApiResponse.fromJson(response.data);
      return AuthResponseDto.fromJson(apiResponse.data);
    });
  }

  @override
  Future<AuthResponseDto> createUser({
    required String firstName,
    String? lastName,
    required String email,
    String? username,
    String? phone,
    required String password,
  }) async {
    return ErrorHandler.handleApiCall(() async {
      final data = {
        'email': email,
        'password': password,
        'first_name': firstName,
        if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
        if (username != null && username.isNotEmpty) 'username': username,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      };

      final response = await _dio.post('/register', data: data);
      final apiResponse = ApiResponse.fromJson(response.data);

      final userDto = AuthResponseDto.fromJson(apiResponse.data);

      return userDto;
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

  @override
  Future<ApiResponse> passwordResetCode({
    required String email,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.post(
        '/password/reset-code',
        data: {'email': email},
      );
      final apiResponse = ApiResponse.fromJson(response.data);
      return apiResponse;
    });
  }

  @override
  Future<ApiResponse> passwordReset({
    required String email,
    required int code,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.post(
        '/password/reset',
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      final apiResponse = ApiResponse.fromJson(response.data);
      return apiResponse;
    });
  }
}
