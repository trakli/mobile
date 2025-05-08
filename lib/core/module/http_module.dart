import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InjectHttpClientModule {
  // InjectHttpClientModule({required this.tokenManager});

  // late TokenManager tokenManager;

  @Named('HttpUrl')
  @dev
  String get devHttpUrl => 'https://api.dev.trakli.app/api/v1/';

  @Named('HttpUrl')
  @prod
  String get prodHttpUrl => 'https://api.trakli.com/api/v1/';

  @lazySingleton
  Dio dio(@Named('HttpUrl') String url) {
    final dio = Dio(
      BaseOptions(baseUrl: url),
    );

    dio.interceptors.addAll([
      // RemoveNullValuesInterceptor(),
      // // TokenInterceptor(tokenManager),
      // LoggerInterceptor()
    ]);

    return dio;
  }
}
