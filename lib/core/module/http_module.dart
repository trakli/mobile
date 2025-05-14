import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/network/interceptors/logger_interceptor.dart';
import 'package:trakli/core/network/interceptors/token_interceptor.dart';
import 'package:trakli/data/datasources/auth/token_manager.dart';
import 'package:trakli/di/injection.dart';

@module
abstract class InjectHttpClientModule {
  // InjectHttpClientModule({required this.tokenManager});

  // late TokenManager tokenManager;

  @Named('HttpUrl')
  String get devHttpUrl => 'https://api.dev.trakli.app/api/v1/';

  // @Named('HttpUrl')
  // @prod
  // String get prodHttpUrl => 'https://api.trakli.com/api/v1/';

  // @lazySingleton
  // TokenManager get tokenManager => TokenManager();

  @lazySingleton
  Dio dio(@Named('HttpUrl') String url) {
    final dio = Dio(
      BaseOptions(baseUrl: url),
    );

    dio.interceptors.addAll([
      // RemoveNullValuesInterceptor(),
      TokenInterceptor(getIt<TokenManager>()),
      LoggerInterceptor()
    ]);

    return dio;
  }
}
