import 'package:dio/dio.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/util/errors.dart';

class ApiService {
  Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api/v1',
    headers: {
      'content-type': 'application/json',
      'Access-Control-Allow-Origin': 'true'
    },
  ));

  Future<String?> register(UserWrapper userWrapper) async {
    try {
      final response =
          await dio.post('/auth/register', data: userWrapper.toJson());
      if (response.statusCode == 200) {
        return response.data.toString();
      }
      return null;
    } on DioError catch (e) {
      print(e.message);

      var errorResponse = e.response;
      if (errorResponse != null) {
        throw ApiError(
            message: e.response!.data['message'], statusCode: e.response!.statusCode!);
      } else {
        throw ApiError(message: 'Unknown ApiError');
      }
    }
  }

  Future<String?> login(UserCredentials userCredentials) async {
    try {
      final response =
          await dio.post('/auth/login', data: userCredentials.toJson());
      if (response.statusCode == 200) {
        return response.data['message'];
      }
      return null;
    } on DioError catch (e) {
      print(e.message);

      var errorResponse = e.response;
      if (errorResponse != null) {
        throw ApiError(
            message: e.response!.data['message'], statusCode: e.response!.statusCode!);
      } else {
        throw ApiError(message: 'Unknown ApiError');
      }
    }
  }
}
