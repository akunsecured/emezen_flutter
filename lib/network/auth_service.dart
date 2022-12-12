import 'package:dio/dio.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/model/wrapped_token.dart';
import 'package:emezen/network/base_service.dart';

class AuthService extends BaseService {
  AuthService() {
    dio.options.baseUrl = '${dio.options.baseUrl}/auth';
  }

  Future<WrappedToken?> register(UserWrapper userWrapper) async {
    try {
      final response = await dio.post('/register', data: userWrapper.toJson());
      if (response.statusCode == 200) {
        print(response.data);
        return WrappedToken.fromJson(response.data['message']);
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }

  Future<WrappedToken?> login(UserCredentials userCredentials) async {
    try {
      final response = await dio.post('/login', data: userCredentials.toJson());
      if (response.statusCode == 200) {
        return WrappedToken.fromJson(
            Map.from(response.data['message']));
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }

  Future<String?> refreshAccessToken(String token) async {
    try {
      final response = await dio.get('/refresh',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return response.data['message'];
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }

  Future<User?> getCurrentUser(String token) async {
    try {
      final response = await dio.get('/current',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        return User.fromJson(response.data['message']);
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }

  Future<bool> deleteUser(String token) async {
    try {
      final response = await dio.delete('/delete',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 204) {
        return true;
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return false;
  }
}
