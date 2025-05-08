import 'package:dio/dio.dart';
import 'package:mini_service_booking_app/core/constants/api_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.connectTimeout = ApiConstants.connectTimeout
      ..options.receiveTimeout = ApiConstants.receiveTimeout
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
  }

  Dio get dio => _dio;
}
