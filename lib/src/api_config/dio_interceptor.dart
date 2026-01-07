import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pecon_app/src/app_config/read_write.dart';

class DioInterceptor extends Interceptor {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = read("token");
    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(response, ResponseInterceptorHandler handler) async {
    String apiPath = response.requestOptions.path;
    String successLog = 'SUCCESS PATH => [${response.requestOptions.method}] $apiPath'; 
    log('\x1B[32m$successLog\x1B[0m');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errormsg = 'ERROR PATH => [${err.response!.requestOptions.method}] ${err.response!.requestOptions.path}';
    log('\x1B[31m$errormsg\x1B[0m');

    // In case of API error
    if(err.response?.statusCode == 403){
      // if (err.response!.data["message"] == "Unauthorized" || err.response!.statusMessage == "Unauthorized"){
      //   showErrorPopUp(message: 'sessionExpiryInfo'.tr);
      //   return;
      // }
    }
    return super.onError(err, handler);
  }
}