import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://intership.hqsolutions.vn/api/',
    // baseUrl: 'https://10.0.2.2:7023/api/',
    connectTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
  ))
    ..httpClientAdapter = IOHttpClientAdapter()
    ..interceptors.add(LogInterceptor(responseBody: true));

  static Dio get instance {
    // Bypass SSL (nếu cần - chỉ dùng khi debug)
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return _dio;
  }
}
