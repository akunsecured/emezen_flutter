import 'package:dio/dio.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/network/api_service.dart';
import 'package:emezen/util/errors.dart';

class AuthService extends ApiService {
  AuthService() {
    dio.options.baseUrl = '${dio.options.baseUrl}/auth';
  }

  void _handleNetworkError(DioError e) {
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

  Future<String?> register(UserWrapper userWrapper) async {
    try {
      final response = await dio.post('/register', data: userWrapper.toJson());
      if (response.statusCode == 200) {
        return response.data.toString();
      }
    } on DioError catch (e) {
      _handleNetworkError(e);
    }
    return null;
  }

  Future<String?> login(UserCredentials userCredentials) async {
    try {
      final response = await dio.post('/login', data: userCredentials.toJson());
      if (response.statusCode == 200) {
        return response.data['message'];
      }
    } on DioError catch (e) {
      _handleNetworkError(e);
    }
    return null;
  }
}
