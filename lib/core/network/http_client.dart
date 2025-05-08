// import 'dart:convert';
// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'package:trakli/core/constants/key_constants.dart';
// import 'package:trakli/core/utils/services/shared_prefs.dart';

// @module
// abstract class HttpClient {
//   HttpClient({required this.preferences});

//   @Named('HttpUrl')
//   @dev
//   String get devHttpUrl => 'https://api.dev.mymocredit.com/api/v1/';

//   @Named('HttpUrl')
//   @prod
//   String get prodHttpUrl => 'https://api.mymocredit.com/api/v1/';

//   // late EnvConfig config;
//   late SharedPrefs preferences;

//   @lazySingleton
//   Dio dio(@Named('HttpUrl') String url) {
//     final header = <String, dynamic>{
//       'isToken': preferences.isKeyExists(KeyConstants.keyAccessToken)
//     };

//     final options = BaseOptions(
//       baseUrl: url,
//       connectTimeout: const Duration(seconds: 20),
//       receiveTimeout: const Duration(seconds: 20),
//       receiveDataWhenStatusError: true,
//       headers: header,
//     );

//     final dio = Dio(options);

//     dio.interceptors.addAll(<Interceptor>[_loggingInterceptor()]);

//     return dio;
//   }

//   Interceptor _loggingInterceptor() {
//     return InterceptorsWrapper(onRequest: (options, handler) {
//       final storageToken = preferences.getString('isToken');

//       final headers = {'Authorization': 'Bearer $storageToken'};

//       log("--> ${options.method} ${"${options.baseUrl}${options.path}"}");
//       log('Headers:');
//       options.headers.forEach((k, dynamic v) => log('$k: $v'));
//       log('queryParameters:');
//       options.queryParameters.forEach((k, dynamic v) => log('$k: $v'));
//       log(
//         '--> END ${options.method}',
//       );

//       if (options.headers.containsKey('isToken')) {
//         options.headers.remove('isToken');
//         options.headers.addAll(headers);
//       }

//       // Do something before request is sent
//       log('\n'
//           '-- headers --\n'
//           '${options.headers.toString()} \n'
//           '-- request -- \n -->body '
//           '${options.data} \n'
//           '');

//       return handler.next(options); //continue
//       // If you want to resolve the request with some custom data，
//       // you can return a `Response` object or return `dio.resolve(data)`.
//       // If you want to reject the request with a error message,
//       // you can return a `DioError` object or return `dio.reject(errMsg)`
//     }, onResponse: (response, handler) {
//       // Do something with response data
//       log('\n'
//           'Response : ${response.requestOptions.uri} \n'
//           '-- headers --\n'
//           '${response.headers.toString()} \n'
//           '-- response --\n'
//           '${jsonEncode(response.data)} \n'
//           '');

//       return handler.next(response); // continue
//     }, onError: (error, handler) {
//       // Do something with response error
//       return handler.next(error); //continue
//     });
//   }
// }
