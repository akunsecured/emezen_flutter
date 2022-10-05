import 'package:dio/dio.dart';
import 'package:emezen/util/errors.dart';

abstract class BaseService {
  late final Dio dio;

  BaseService() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1'
    ));
  }

  void handleNetworkError(DioError e) {
    if (e.response != null) {
      throw ApiError(
          message: e.response!.data['message'],
          statusCode: e.response!.statusCode!);
    } else {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          throw ApiError(message: 'Connection timed out');
        case DioErrorType.sendTimeout:
          throw ApiError(message: 'Send timed out');
        case DioErrorType.receiveTimeout:
          throw ApiError(message: 'Receive timed out');
        case DioErrorType.response:
          throw ApiError(message: "Can't connect to the server");
        default:
          throw ApiError(message: 'Something went wrong');
      }
    }
  }
}