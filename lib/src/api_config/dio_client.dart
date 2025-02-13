import 'package:dio/dio.dart';
import 'package:pecon/src/api_config/dio_interceptor.dart';
import 'package:pecon/src/app_config/constant.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: getBaseUrl(),
    headers: <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    receiveDataWhenStatusError: true,
    // connectTimeout: const Duration(seconds: 30), // 30 seconds
    // receiveTimeout: const Duration(seconds: 30)
  ),
)..interceptors.add(DioInterceptor());


